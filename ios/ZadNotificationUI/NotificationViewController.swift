import SwiftUI
import UIKit
import UserNotifications
import UserNotificationsUI

/// Ready-to-wire Notification Content Extension controller for Lockscreen expanded UI.
/// Displays Adhan post-prayer duaa or interactive Azkar counter directly on the iOS Lock Screen.
class NotificationViewController: UIViewController, UNNotificationContentExtension {
  private let suiteName = "group.com.ibrahimnasser.zadalmuslim.shared"
  private var hostingController: UIHostingController<LockExtensionSanctuaryView>?

  func didReceive(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    let mode = userInfo["mode"] as? String ?? "adhan"
    let isArabic = (userInfo["languageCode"] as? String ?? "ar") == "ar"
    let defaults = UserDefaults(suiteName: suiteName) ?? .standard

    let root = LockExtensionSanctuaryView(
      mode: mode,
      userInfo: userInfo,
      isArabic: isArabic,
      sharedDefaults: defaults
    )
    let host = UIHostingController(rootView: root)
    addChild(host)
    host.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(host.view)
    NSLayoutConstraint.activate([
      host.view.topAnchor.constraint(equalTo: view.topAnchor),
      host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    host.didMove(toParent: self)
    hostingController = host
  }
}

struct LockExtensionSanctuaryView: View {
  let mode: String
  let userInfo: [AnyHashable: Any]
  let isArabic: Bool
  let sharedDefaults: UserDefaults

  @State private var dhikrIndex = 0
  @State private var remaining = 1

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(red: 0.03, green: 0.08, blue: 0.10), Color(red: 0.08, green: 0.23, blue: 0.29)],
        startPoint: .top,
        endPoint: .bottom
      )

      VStack(spacing: 12) {
        if mode == "azkar" {
          azkarCard
        } else {
          adhanCard
        }
      }
      .padding(18)
    }
  }

  private var adhanCard: some View {
    let prayerTitle = isArabic
      ? (userInfo["titleAr"] as? String ?? "الفجر")
      : (userInfo["titleEn"] as? String ?? "Fajr")
    let muezzin = isArabic
      ? (userInfo["muezzinNameAr"] as? String ?? "أذان الحرم المكي")
      : (userInfo["muezzinNameEn"] as? String ?? "Makkah Sanctuary")

    return VStack(spacing: 10) {
      Text(isArabic ? "صلاة \(prayerTitle)" : "\(prayerTitle) Prayer")
        .font(.system(size: 24, weight: .bold, design: .serif))
        .foregroundColor(.white)
      Text(muezzin)
        .font(.caption)
        .foregroundColor(Color(red: 0.88, green: 0.72, blue: 0.40))
      Text("اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ")
        .font(.system(size: 15, design: .serif))
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .padding(.top, 4)
      Text("صحيح البخاري • حديث 614")
        .font(.caption2)
        .foregroundColor(Color(red: 0.88, green: 0.72, blue: 0.40))
    }
  }

  private var azkarCard: some View {
    let categoryId = userInfo["categoryId"] as? String ?? "morning"
    let items = loadStoredAzkar(categoryId: categoryId)
    let current = items.isEmpty ? nil : items[min(dhikrIndex, items.count - 1)]
    let text = current?["arabicText"] as? String ?? "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ"
    let dhikrId = current?["id"] as? String ?? "m_1"
    let target = current?["targetCount"] as? Int ?? 1

    return VStack(spacing: 12) {
      Text(isArabic ? (categoryId == "evening" ? "أذكار المساء 🌙" : "أذكار الصباح ☀️") : "Daily Azkar")
        .font(.subheadline.bold())
        .foregroundColor(Color(red: 0.88, green: 0.72, blue: 0.40))
      Text(text)
        .font(.system(size: 16, design: .serif))
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
      Button(action: {
        let nextRem = max(remaining - 1, 0)
        remaining = nextRem
        recordUpdate(categoryId: categoryId, dhikrId: dhikrId, remaining: nextRem)
        if nextRem == 0 && dhikrIndex + 1 < items.count {
          dhikrIndex += 1
          remaining = items[dhikrIndex]["targetCount"] as? Int ?? 1
        }
      }) {
        Text(isArabic ? "تسبيح (\(remaining))" : "Tap (\(remaining))")
          .font(.subheadline.bold())
          .foregroundColor(.white)
          .padding(.horizontal, 24)
          .padding(.vertical, 10)
          .background(Color(red: 0.11, green: 0.37, blue: 0.31))
          .cornerRadius(20)
      }
    }
    .onAppear { remaining = target }
  }

  private func loadStoredAzkar(categoryId: String) -> [[String: Any]] {
    guard let data = sharedDefaults.data(forKey: "azkar_payload_json"),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      return []
    }
    let key = categoryId == "evening" ? "eveningItems" : "morningItems"
    return json[key] as? [[String: Any]] ?? []
  }

  private func recordUpdate(categoryId: String, dhikrId: String, remaining: Int) {
    var list = (sharedDefaults.array(forKey: "pending_dhikr_updates") as? [[String: Any]]) ?? []
    list.removeAll { ($0["categoryId"] as? String) == categoryId && ($0["dhikrId"] as? String) == dhikrId }
    list.append(["categoryId": categoryId, "dhikrId": dhikrId, "remaining": remaining])
    sharedDefaults.set(list, forKey: "pending_dhikr_updates")
  }
}
