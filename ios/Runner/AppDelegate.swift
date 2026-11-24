import AVFoundation
import Flutter
import SwiftUI
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UNUserNotificationCenterDelegate {
  private var nativeChannel: FlutterMethodChannel?
  private var audioPlayer: AVAudioPlayer?
  private let suiteName = "group.com.example.islamicApp.shared"

  private var sharedDefaults: UserDefaults {
    UserDefaults(suiteName: suiteName) ?? .standard
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    registerNotificationCategories(center: center)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "com.example.islamic_app/native_alarms",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    nativeChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handleMethodCall(call, result: result)
    }
  }

  private func registerNotificationCategories(center: UNUserNotificationCenter) {
    let stopAdhan = UNNotificationAction(
      identifier: "STOP_ADHAN",
      title: "إيقاف الأذان • Stop",
      options: [.destructive]
    )
    let openQibla = UNNotificationAction(
      identifier: "OPEN_QIBLA",
      title: "القبلة • Qibla",
      options: [.foreground]
    )
    let adhanCategory = UNNotificationCategory(
      identifier: "ADHAN_CATEGORY",
      actions: [openQibla, stopAdhan],
      intentIdentifiers: [],
      options: [.customDismissAction]
    )

    let startAzkar = UNNotificationAction(
      identifier: "START_AZKAR",
      title: "بدء الأذكار • Start Azkar",
      options: [.foreground]
    )
    let snoozeAzkar = UNNotificationAction(
      identifier: "SNOOZE_AZKAR",
      title: "تأجيل ٣٠ د • Snooze 30m",
      options: []
    )
    let azkarCategory = UNNotificationCategory(
      identifier: "AZKAR_CATEGORY",
      actions: [startAzkar, snoozeAzkar],
      intentIdentifiers: [],
      options: []
    )
    center.setNotificationCategories([adhanCategory, azkarCategory])
  }

  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "syncPrayerSchedule":
      guard let args = call.arguments as? [String: Any] else {
        result(false)
        return
      }
      syncPrayerSchedule(args)
      result(true)
    case "syncAzkarSchedule":
      guard let args = call.arguments as? [String: Any] else {
        result(false)
        return
      }
      syncAzkarSchedule(args)
      result(true)
    case "cancelPrayerAlarms":
      cancelRequests(withPrefixes: ["zad_pre_", "zad_adhan_"])
      result(nil)
    case "cancelAzkarAlarms":
      cancelRequests(withPrefixes: ["zad_azkar_"])
      result(nil)
    case "consumePendingLaunchRoute":
      result(consumePendingRoute())
    case "consumeDhikrUpdates":
      result(consumeDhikrUpdates())
    case "checkReliability":
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        let allowed = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
        DispatchQueue.main.async {
          result([
            "notifications": allowed,
            "exactAlarms": true,
            "batteryUnrestricted": true,
            "fullScreenIntent": true,
          ])
        }
      }
    case "requestPermissions":
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        DispatchQueue.main.async { result(granted) }
      }
    case "previewNativeAdhan":
      if let args = call.arguments as? [String: Any] {
        presentNativeSanctuary(mode: "adhan", payload: args)
      }
      result(nil)
    case "previewNativeAzkar":
      if let args = call.arguments as? [String: Any] {
        presentNativeSanctuary(mode: "azkar", payload: args)
      }
      result(nil)
    case "openBatterySettings", "openExactAlarmSettings", "openFullScreenIntentSettings":
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func syncPrayerSchedule(_ payload: [String: Any]) {
    if let data = try? JSONSerialization.data(withJSONObject: payload) {
      sharedDefaults.set(data, forKey: "prayer_payload_json")
    }
    cancelRequests(withPrefixes: ["zad_pre_", "zad_adhan_"])

    let adhanEnabled = payload["adhanEnabled"] as? Bool ?? false
    let preEnabled = payload["preAlertEnabled"] as? Bool ?? false
    guard adhanEnabled || preEnabled, let entries = payload["entries"] as? [[String: Any]] else { return }

    let lang = payload["languageCode"] as? String ?? "ar"
    let isArabic = lang == "ar"
    let muezzinAr = payload["muezzinNameAr"] as? String ?? ""
    let muezzinEn = payload["muezzinNameEn"] as? String ?? ""
    let nowMs = Date().timeIntervalSince1970 * 1000.0
    let center = UNUserNotificationCenter.current()

    for entry in entries {
      let key = entry["prayerKey"] as? String ?? "fajr"
      let titleAr = entry["titleAr"] as? String ?? "الفجر"
      let titleEn = entry["titleEn"] as? String ?? "Fajr"
      let preId = entry["preId"] as? Int ?? 1000
      let adhanId = entry["adhanId"] as? Int ?? 2000
      let preMs = entry["preAtMillis"] as? Double ?? 0
      let adhanMs = entry["adhanAtMillis"] as? Double ?? 0
      let iosSound = entry["iosSound"] as? String ?? ""

      if preEnabled && preMs > nowMs {
        let content = UNMutableNotificationContent()
        content.title = isArabic ? "اقترب موعد صلاة \(titleAr)" : "\(titleEn) Prayer in 5m"
        content.body = isArabic ? "بقي 5 دقائق لدخول وقت الصلاة • استعد للوضوء" : "5 minutes until prayer • Prepare for Wudu"
        content.sound = .default
        if #available(iOS 15.0, *) { content.interruptionLevel = .timeSensitive }
        scheduleNotification(center: center, id: "zad_pre_\(preId)", timestampMs: preMs, content: content)
      }

      if adhanEnabled && adhanMs > nowMs {
        let content = UNMutableNotificationContent()
        content.title = isArabic ? "حان الآن موعد صلاة \(titleAr)" : "Time for \(titleEn) Prayer"
        content.subtitle = isArabic ? muezzinAr : muezzinEn
        content.body = isArabic ? "الله أكبر • حي على الصلاة • حي على الفلاح" : "Allahu Akbar • Come to Prayer"
        content.categoryIdentifier = "ADHAN_CATEGORY"
        content.userInfo = [
          "mode": "adhan",
          "prayerKey": key,
          "titleAr": titleAr,
          "titleEn": titleEn,
          "prayerTimeMillis": adhanMs,
          "muezzinNameAr": muezzinAr,
          "muezzinNameEn": muezzinEn,
          "languageCode": lang,
        ]
        content.sound = resolveCafSound(iosSound)
        if #available(iOS 15.0, *) { content.interruptionLevel = .timeSensitive }
        scheduleNotification(center: center, id: "zad_adhan_\(adhanId)", timestampMs: adhanMs, content: content)
      }
    }
  }

  private func syncAzkarSchedule(_ payload: [String: Any]) {
    if let data = try? JSONSerialization.data(withJSONObject: payload) {
      sharedDefaults.set(data, forKey: "azkar_payload_json")
    }
    cancelRequests(withPrefixes: ["zad_azkar_"])

    guard payload["enabled"] as? Bool ?? false,
          let triggers = payload["triggers"] as? [[String: Any]] else { return }

    let lang = payload["languageCode"] as? String ?? "ar"
    let isArabic = lang == "ar"
    let nowMs = Date().timeIntervalSince1970 * 1000.0
    let center = UNUserNotificationCenter.current()

    for trigger in triggers {
      let id = trigger["id"] as? Int ?? 3000
      let categoryId = trigger["categoryId"] as? String ?? "morning"
      let atMs = trigger["atMillis"] as? Double ?? 0
      guard atMs > nowMs else { continue }

      let isMorning = categoryId == "morning"
      let content = UNMutableNotificationContent()
      content.title = isArabic ? (isMorning ? "أذكار الصباح ☀️" : "أذكار المساء 🌙") : (isMorning ? "Morning Azkar ☀️" : "Evening Azkar 🌙")
      content.body = isArabic ? "اضغط مطولاً أو افتح لقراءة الأذكار التفاعلية" : "Press & hold or tap for interactive Azkar"
      content.sound = .default
      content.categoryIdentifier = "AZKAR_CATEGORY"
      content.userInfo = ["mode": "azkar", "categoryId": categoryId, "languageCode": lang]
      if #available(iOS 15.0, *) { content.interruptionLevel = .timeSensitive }
      scheduleNotification(center: center, id: "zad_azkar_\(id)", timestampMs: atMs, content: content)
    }
  }

  private func scheduleNotification(
    center: UNUserNotificationCenter,
    id: String,
    timestampMs: Double,
    content: UNMutableNotificationContent
  ) {
    let date = Date(timeIntervalSince1970: timestampMs / 1000.0)
    let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
    let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    center.add(req)
  }

  private func resolveCafSound(_ fileName: String) -> UNNotificationSound {
    let base = fileName.replacingOccurrences(of: ".caf", with: "")
    if !base.isEmpty, Bundle.main.url(forResource: base, withExtension: "caf") != nil {
      return UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(base).caf"))
    }
    return .default
  }

  private func cancelRequests(withPrefixes prefixes: [String]) {
    let center = UNUserNotificationCenter.current()
    center.getPendingNotificationRequests { requests in
      let matching = requests.map(\.identifier).filter { id in prefixes.contains { id.hasPrefix($0) } }
      center.removePendingNotificationRequests(withIdentifiers: matching)
    }
  }

  private func presentNativeSanctuary(mode: String, payload: [String: Any]) {
    DispatchQueue.main.async {
      guard let rootVc = self.topViewController() else { return }
      if mode == "adhan" {
        self.startFullAdhanAudio(rawSound: payload["rawSound"] as? String ?? "al_harram_fajr")
      }
      let view = NativeSanctuarySheet(
        mode: mode,
        payload: payload,
        onStopAudio: { [weak self] in self?.stopAudio() },
        onRecordDhikrUpdate: { [weak self] catId, dhikrId, remaining in
          self?.recordDhikrUpdate(categoryId: catId, dhikrId: dhikrId, remaining: remaining)
        },
        onOpenRoute: { [weak self, weak rootVc] route, args in
          self?.stopAudio()
          rootVc?.dismiss(animated: true) {
            self?.dispatchOrStoreRoute(route, args: args)
          }
        },
        onDismiss: { [weak self, weak rootVc] in
          self?.stopAudio()
          rootVc?.dismiss(animated: true)
        }
      )
      let host = UIHostingController(rootView: view)
      host.modalPresentationStyle = .fullScreen
      rootVc.present(host, animated: true)
    }
  }

  private func startFullAdhanAudio(rawSound: String) {
    stopAudio()
    let assetSubpath = switch rawSound {
    case "abdulbasit_fajr": "audio/abdulbasit/abd-elbaset-fajr"
    case "abdulbasit_regular": "audio/abdulbasit/abd-elbaset-regular"
    case "alafasy_fajr": "audio/alafasy/alafasy-fajr"
    case "alafasy_regular": "audio/alafasy/alafasy-regular"
    case "al_harram_fajr": "audio/harram/al-harram-fajr"
    default: "audio/harram/al-harram-regular"
    }
    guard let path = Bundle.main.path(forResource: "Frameworks/App.framework/flutter_assets/assets/\(assetSubpath)", ofType: "mp3") else {
      return
    }
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    try? AVAudioSession.sharedInstance().setActive(true)
    audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    audioPlayer?.play()
  }

  private func stopAudio() {
    audioPlayer?.stop()
    audioPlayer = nil
  }

  private func recordDhikrUpdate(categoryId: String, dhikrId: String, remaining: Int) {
    var list = (sharedDefaults.array(forKey: "pending_dhikr_updates") as? [[String: Any]]) ?? []
    list.removeAll { ($0["categoryId"] as? String) == categoryId && ($0["dhikrId"] as? String) == dhikrId }
    list.append(["categoryId": categoryId, "dhikrId": dhikrId, "remaining": remaining])
    sharedDefaults.set(list, forKey: "pending_dhikr_updates")
  }

  private func consumeDhikrUpdates() -> [[String: Any]] {
    let list = (sharedDefaults.array(forKey: "pending_dhikr_updates") as? [[String: Any]]) ?? []
    sharedDefaults.removeObject(forKey: "pending_dhikr_updates")
    return list
  }

  private func dispatchOrStoreRoute(_ route: String, args: [String: Any]?) {
    if let channel = nativeChannel {
      channel.invokeMethod("openRoute", arguments: ["route": route, "args": args as Any])
    } else {
      sharedDefaults.set(route, forKey: "pending_launch_route")
      if let args { sharedDefaults.set(args, forKey: "pending_launch_args") }
    }
  }

  private func consumePendingRoute() -> [String: Any]? {
    guard let route = sharedDefaults.string(forKey: "pending_launch_route") else { return nil }
    let args = sharedDefaults.dictionary(forKey: "pending_launch_args")
    sharedDefaults.removeObject(forKey: "pending_launch_route")
    sharedDefaults.removeObject(forKey: "pending_launch_args")
    return ["route": route, "args": args as Any]
  }

  private func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    var top = scenes.first(where: { $0.activationState == .foregroundActive })?.windows.first(where: \.isKeyWindow)?.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .sound, .list])
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    if response.actionIdentifier == "STOP_ADHAN" {
      stopAudio()
    } else if response.actionIdentifier == "OPEN_QIBLA" {
      dispatchOrStoreRoute("/qibla", args: nil)
    } else if response.actionIdentifier == "START_AZKAR" || (userInfo["mode"] as? String) == "azkar" {
      let cat = userInfo["categoryId"] as? String ?? "morning"
      dispatchOrStoreRoute("/azkar-category", args: ["categoryId": cat])
    } else if response.actionIdentifier == "SNOOZE_AZKAR" {
      let cat = userInfo["categoryId"] as? String ?? "morning"
      let lang = userInfo["languageCode"] as? String ?? "ar"
      let content = UNMutableNotificationContent()
      content.title = lang == "ar" ? "تذكير الأذكار" : "Azkar Reminder"
      content.body = lang == "ar" ? "حان موعد الأذكار المؤجل" : "Time for your snoozed Azkar"
      content.categoryIdentifier = "AZKAR_CATEGORY"
      content.userInfo = ["mode": "azkar", "categoryId": cat, "languageCode": lang]
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30 * 60, repeats: false)
      center.add(UNNotificationRequest(identifier: "zad_azkar_snooze", content: content, trigger: trigger))
    } else if (userInfo["mode"] as? String) == "adhan" {
      var mapped: [String: Any] = [:]
      for (k, v) in userInfo { mapped["\(k)"] = v }
      presentNativeSanctuary(mode: "adhan", payload: mapped)
    }
    completionHandler()
  }
}

private struct NativeSanctuarySheet: View {
  let mode: String
  let payload: [String: Any]
  let onStopAudio: () -> Void
  let onRecordDhikrUpdate: (String, String, Int) -> Void
  let onOpenRoute: (String, [String: Any]?) -> Void
  let onDismiss: () -> Void

  @State private var isPlaying = true
  @State private var index = 0
  @State private var remaining = 3

  var body: some View {
    let isArabic = (payload["languageCode"] as? String ?? "ar") == "ar"
    ZStack {
      LinearGradient(
        colors: [Color(red: 0.03, green: 0.08, blue: 0.10), Color(red: 0.08, green: 0.23, blue: 0.29)],
        startPoint: .top,
        endPoint: .bottom
      ).ignoresSafeArea()

      VStack(spacing: 18) {
        if mode == "azkar" {
          azkarContent(isArabic: isArabic)
        } else {
          adhanContent(isArabic: isArabic)
        }
      }
      .padding(22)
    }
  }

  @ViewBuilder
  private func adhanContent(isArabic: Bool) -> some View {
    let titleAr = payload["titleAr"] as? String ?? "الفجر"
    let titleEn = payload["titleEn"] as? String ?? "Fajr"
    let muezzinAr = payload["muezzinNameAr"] as? String ?? "أذان الحرم المكي"
    let muezzinEn = payload["muezzinNameEn"] as? String ?? "Makkah Sanctuary"

    Text(isArabic ? "الآن موعد صلاة \(titleAr)" : "\(titleEn) Prayer Time")
      .font(.headline).foregroundColor(.white)
      .padding(.horizontal, 16).padding(.vertical, 8)
      .background(Color.white.opacity(0.1)).cornerRadius(20)

    Spacer()
    Text(isArabic ? "صلاة \(titleAr)" : "\(titleEn) Prayer")
      .font(.system(size: 34, weight: .bold, design: .serif)).foregroundColor(.white)
    Text(isArabic ? muezzinAr : muezzinEn)
      .font(.subheadline).foregroundColor(Color(red: 0.88, green: 0.72, blue: 0.40))

    Text("اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ")
      .font(.system(size: 18, design: .serif)).foregroundColor(.white)
      .multilineTextAlignment(.center).padding(18)
      .background(Color.white.opacity(0.08)).cornerRadius(20)
    Spacer()

    Button(action: {
      if isPlaying {
        isPlaying = false
        onStopAudio()
      } else {
        onDismiss()
      }
    }) {
      Text(isPlaying ? (isArabic ? "إيقاف الأذان" : "Stop Adhan") : (isArabic ? "تم • إغلاق" : "Done"))
        .font(.headline).foregroundColor(.white)
        .frame(maxWidth: .infinity).frame(height: 54)
        .background(isPlaying ? Color(red: 0.72, green: 0.11, blue: 0.11) : Color(red: 0.11, green: 0.37, blue: 0.31))
        .cornerRadius(27)
    }

    HStack(spacing: 12) {
      Button(isArabic ? "اتجاه القبلة" : "Qibla") { onOpenRoute("/qibla", nil) }
        .frame(maxWidth: .infinity).frame(height: 46)
        .background(Color.white.opacity(0.12)).foregroundColor(.white).cornerRadius(23)
      Button(isArabic ? "فتح زاد المسلم" : "Open App") { onOpenRoute("/home", nil) }
        .frame(maxWidth: .infinity).frame(height: 46)
        .background(Color.white.opacity(0.12)).foregroundColor(.white).cornerRadius(23)
    }
  }

  @ViewBuilder
  private func azkarContent(isArabic: Bool) -> some View {
    let catId = payload["categoryId"] as? String ?? "morning"
    let items = (payload["items"] as? [[String: Any]]) ?? []
    let safeIndex = min(index, max(items.count - 1, 0))
    let current = items.isEmpty ? nil : items[safeIndex]
    let dhikrId = current?["id"] as? String ?? "m_1"
    let target = current?["targetCount"] as? Int ?? 1
    let text = current?["arabicText"] as? String ?? "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ"

    Text((isArabic ? "أذكار \(catId == "evening" ? "المساء" : "الصباح")" : "Daily Azkar") + " • \(safeIndex + 1)/\(max(items.count, 1))")
      .font(.headline).foregroundColor(.white)
      .padding(.horizontal, 16).padding(.vertical, 8)
      .background(Color.white.opacity(0.1)).cornerRadius(20)

    Spacer()
    ScrollView {
      Text(text).font(.system(size: 20, design: .serif)).foregroundColor(.white)
        .multilineTextAlignment(.center).padding(20)
    }.background(Color.white.opacity(0.08)).cornerRadius(22)
    Spacer()

    Button(action: {
      let currentRem = remaining > 0 ? remaining - 1 : 0
      remaining = currentRem
      UIImpactFeedbackGenerator(style: .light).impactOccurred()
      onRecordDhikrUpdate(catId, dhikrId, currentRem)
      if currentRem == 0 && safeIndex + 1 < items.count {
        index += 1
        remaining = items[safeIndex + 1]["targetCount"] as? Int ?? 1
      }
    }) {
      VStack {
        Text("\(remaining)").font(.system(size: 30, weight: .bold))
        Text(isArabic ? "تسبيح" : "Tap").font(.caption)
      }
      .foregroundColor(.white)
      .frame(width: 112, height: 112)
      .background(Color(red: 0.11, green: 0.37, blue: 0.31))
      .clipShape(Circle())
      .overlay(Circle().stroke(Color(red: 0.88, green: 0.72, blue: 0.40), lineWidth: 4))
    }
    .onAppear { remaining = target }

    HStack(spacing: 12) {
      Button(isArabic ? "كل الأذكار" : "Full Azkar") { onOpenRoute("/azkar-category", ["categoryId": catId]) }
        .frame(maxWidth: .infinity).frame(height: 46)
        .background(Color(red: 0.11, green: 0.37, blue: 0.31)).foregroundColor(.white).cornerRadius(23)
      Button(isArabic ? "إغلاق" : "Close") { onDismiss() }
        .frame(maxWidth: .infinity).frame(height: 46)
        .background(Color.white.opacity(0.12)).foregroundColor(.white).cornerRadius(23)
    }
  }
}
