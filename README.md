# 🕊️ زاد المسلم | Zad Al-Muslim

<div align="center">

<img src="assets/images/app_logo.png" alt="Zad Al-Muslim Logo" width="120" />

### رفيقك اليومي في الصلاة والقرآن والأذكار — بلا إعلانات ولا تتبع
**An offline-first Flutter Islamic companion with native Android/iOS lockscreen Adhan & Azkar engines, Drift SQLite storage, and zero ads or tracking.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.14%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Android Native](https://img.shields.io/badge/Android-Kotlin%20AlarmClock%20%2B%20ForegroundService-3DDC84?logo=android&logoColor=white)](#-المنظومة-الأصلية-للأذان-وشاشة-القفل--native-adhan--azkar-engine)
[![iOS Native](https://img.shields.io/badge/iOS-Time%20Sensitive%20%2B%20SwiftUI-000000?logo=apple&logoColor=white)](ios/NATIVE_IOS_SETUP.md)
[![Storage](https://img.shields.io/badge/Storage-Drift%20SQLite-0D9488)](#-التقنيات-المستخدمة--tech-stack)
[![License](https://img.shields.io/badge/License-Waqf%20%2F%20Open%20Source-teal)](#-صدقة-جارية--waqf)

> **﴿ وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَىٰ وَاتَّقُونِ يَا أُولِي الْأَلْبَابِ ﴾** — *[سورة البقرة: 197]*

</div>

---

## ⚡ البدء السريع (Quick Start < 5 min)

```bash
# 1. تثبيت الحزم
flutter pub get

# 2. توليد جداول Drift (اختياري عند تعديل السكيما)
dart run build_runner build --delete-conflicting-outputs

# 3. التحليل الساكن والاختبارات
flutter analyze --no-fatal-infos
flutter test

# 4. تشغيل التطبيق
flutter run
```

---

## ✨ المميزات الرئيسية | Key Features

| الميزة | الوصف المختصر |
| :--- | :--- |
| **الشاشة الرئيسية المتكيفة** | واجهة `CustomScrollView` مع شريط علوي مثبّت (`CompactPinnedHeroCard`) وأجواء سماء متغيرة حسب وقت الصلاة. |
| **مواقيت الصلاة والقبلة** | حساب فلكي محلي دون إنترنت عبر `adhan` مع GPS أو اختيار المدينة يدوياً، وبوصلة قبلة تفاعلية. |
| **الأذان وشاشة القفل الأصلية** | محرك `Kotlin` (`AlarmClock` + `AdhanForegroundService` + `SanctuaryLockActivity`) و`Swift` يعمل فوق شاشة القفل دون انقطاع. |
| **المصحف والوِرد اليومي** | تلاوة القرآن بالرسم العثماني مع البحث والإشارات، ومتتبع **الوِرد القرآني اليومي** المتسلسل (`DailyWirdCubit`). |
| **الأذكار والسبحة الإلكترونية** | أذكار مؤقتة حسب الوقت ومزامنة ثنائية مع نافذة شاشة القفل، وسبحة تفاعلية بوضعَي الحر والوِرد. |
| **المساجد القريبة والحديث** | خريطة `OpenStreetMap` للمساجد القريبة عند الطلب فقط، ومكتبة أحاديث نبوية محلية بالكامل. |
| **الخصوصية والأذونات** | شاشة **سياسة الخصوصية** داخل الإعدادات (`Routes.privacyPolicy`) وقائمة فحص الجاهزية (`PermissionsChecklistSheet`). |

---

## 🎙️ المصادر الصوتية والشرعية | Credits & Sources

- **تسجيلات صوت الأذان (مكة المكرمة، عبد الباسط عبد الصمد، مشاري العفاسي)**: مأخوذة من موقع **[islamweb.net](https://www.islamweb.net)** ومضمّنة محلياً للعمل دون اتصال بالإنترنت.
- **النصوص المقدسة**: تبقى آيات القرآن الكريم والأذكار النبوية بنصها العربي الأصيل في جميع لغات التطبيق (`ar` / `en`).

---

## 🏗️ هيكلية المشروع | Architecture

يتبع المشروع معمارية **Clean Architecture + MVVM (`BLoC / Cubit`)** مع قاعدة بيانات **Drift SQLite** وحقن اعتماديات عبر **GetIt**:

```text
lib/
├── core/
│   ├── config/         # AppConfig (الهوية، البريد، ومصدر صوت الأذان)
│   ├── database/       # AppDatabase (Drift SQLite) + DAOs + SharedPrefsToDriftMigrator
│   ├── di/             # تسجيل GetIt (lib/core/di/injection_container.dart)
│   ├── routes/         # Routes & AppRouter
│   ├── services/       # native/ (MethodChannel + Permissions) & notification/ (7-day schedulers)
│   ├── theme/          # Semantic ThemeExtensions (بدون أي شروط isDark)
│   └── widgets/        # المكونات الموحدة (AppDialogs, CustomButton, PermissionsChecklistSheet...)
├── features/
│   ├── adhan/          # شاشة الأذان والتنبيهات
│   ├── azkar/          # الأذكار اليومية والمؤقتة والمزامنة الأصلية
│   ├── hadith/         # كتب الحديث وشروحها
│   ├── home/           # CustomScrollView + Pinned Hero + Timed Azkar + Daily Wird
│   ├── mosques/        # خريطة ودليل المساجد القريبة (Photon / Overpass / OSM)
│   ├── onboarding/     # شرائح التهيئة وميثاق الأذونات
│   ├── qibla/          # بوصلة القبلة
│   ├── quran/          # المصحف الشريف والوِرد اليومي
│   ├── settings/       # الإعدادات، اختيار المؤذن، وشاشة سياسة الخصوصية
│   ├── splash/         # الإطلاق الذكي وتوجيه الإشعارات
│   └── tasbeeh/        # السبحة الإلكترونية وسجلات الأوراد
└── main.dart
```

<details>
<summary>📂 الطبقات الأصلية (Android Kotlin & iOS Swift)</summary>

- **Android (`android/app/src/main/kotlin/com/example/islamic_app/alarm/`)**: `NativeAlarmScheduler.kt`, `AdhanForegroundService.kt`, `SanctuaryLockActivity.kt`, `AdhanLockPresenter.kt`, `AzkarLockPresenter.kt`, `Receivers.kt`, `NativeMethodChannelHandler.kt`.
- **iOS (`ios/`)**: `Runner/AppDelegate.swift`, `ZadNotificationUI/NotificationViewController.swift`, راجع [ios/NATIVE_IOS_SETUP.md](ios/NATIVE_IOS_SETUP.md).

</details>

---

## 🛠️ التقنيات المستخدمة | Tech Stack

| التقنية | الدور |
| :--- | :--- |
| `flutter_bloc` / `bloc` | إدارة الحالة (MVVM / Cubit) |
| `drift` / `drift_flutter` | التخزين المحلي المنظّم (SQLite) |
| `get_it` / `dartz` | حقن الاعتماديات ومعالجة الأخطاء الوظيفية |
| `easy_localization` | التعريب الكامل (`assets/lang/ar.json` & `en.json`) |
| `adhan` / `geolocator` / `flutter_compass` | حساب المواقيت محلياً والموقع والقبلة |
| `flutter_map` / `dio` | خرائط المساجد القريبة (`OpenStreetMap`) |
| `flutter_local_notifications` / `audioplayers` | التنبيهات المرجعية وتشغيل المعاينات الصوتية |

---

## 📦 إعداد النشر على Google Play | Release & Play Store Config

| الإعداد | التفاصيل |
| :--- | :--- |
| **Application ID** | `com.ibrahimnasser.zadalmuslim` في `android/app/build.gradle.kts` |
| **توقيع الإصدار (Release Signing)** | أنشئ ملف `android/key.properties` بمفاتيح `storeFile` و`storePassword` و`keyAlias` و`keyPassword`؛ عند عدم وجوده محلياً يسقط بأمان للتوقيع التجريبي، كما أن `key.properties` و`*.jks` مستبعدة في `.gitignore`. |
| **الصلاحيات** | يستخدم `SCHEDULE_EXACT_ALARM` و`USE_FULL_SCREEN_INTENT` و`FOREGROUND_SERVICE_MEDIA_PLAYBACK` مع استبعاد الأذونات المقيدة (`USE_EXACT_ALARM` و`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`). |
| **رابط سياسة الخصوصية** | صفحة `/privacy` في الموقع التعريفي الرسمي (`islamic_app_landing`) مطابقة تماماً لشاشة الخصوصية داخل التطبيق. |

---

## 🤲 صدقة جارية | Waqf

تطبيق **زاد المسلم** مجاني بالكامل وخالٍ من الإعلانات والتتبع، متاح كصدقة جارية لوجه الله تعالى. للتواصل: `ibrahimnasser.mobile@gmail.com`.
