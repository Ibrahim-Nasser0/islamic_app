# دليل إعداد إضافات iOS الأصلية على macOS (Xcode Setup)

تم تجهيز الجسر البرمجي الكامل في `ios/Runner/AppDelegate.swift` و `ios/Runner/Info.plist`، كما تم تجهيز شيفرة الواجهة التفاعلية الموسّعة لشاشة القفل في `ios/ZadNotificationUI/`. لأن إضافة Notification Content Extension وتفعيل App Groups يتطلبان **Xcode على macOS**، اتبع الخطوات التالية عند البناء على Mac:

## 1. تحويل مقاطع الأذان إلى `.caf` (بحد أقصى 29 ثانية لقيد Apple)
```bash
mkdir -p ios/Runner/Sounds
for f in abdulbasit_regular abdulbasit_fajr alafasy_regular alafasy_fajr al_harram_regular al_harram_fajr; do
  ffmpeg -y -i android/app/src/main/res/raw/${f}.mp3 -t 29 -acodec ima4 -ar 22050 ios/Runner/Sounds/${f}.caf
done
```
ثم اسحب مجلد `Sounds/` إلى Target `Runner` داخل Xcode مع تفعيل **"Copy items if needed"** و **"Add to targets: Runner"**.

## 2. تفعيل الصلاحيات في Target `Runner`
1. افتح `ios/Runner.xcworkspace` في Xcode.
2. في **Signing & Capabilities** أضف:
   - **Time Sensitive Notifications**
   - **App Groups** وأضف المعرّف: `group.com.example.islamicApp.shared`

## 3. ربط واجهة شاشة القفل التفاعلية (`ZadNotificationUI`)
1. من Xcode: **File → New → Target → Notification Content Extension** باسم `ZadNotificationUI`.
2. فعّل فيه نفس **App Groups** (`group.com.example.islamicApp.shared`).
3. استبدل ملفات `NotificationViewController.swift` و `Info.plist` بالملفات الجاهزة في `ios/ZadNotificationUI/`.
4. في قائمة Actions يظهر الإشعار مرفقاً بالتصميم الذهبي والزمردي وعدّاد الأذكار مباشرة فوق شاشة القفل دون الحاجة لفتح التطبيق!
