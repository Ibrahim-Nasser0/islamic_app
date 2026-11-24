# 🕊️ زاد المسلم | Zad Al-Muslim

<div align="center">

<img src="assets/images/app_logo.png" alt="Zad Al-Muslim Logo" width="130" />

### رفيقك اليومي في الذكر والعبادة والقرآن الكريم
**Your Daily Companion for Worship, Dhikr, and Quran Recitation**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Android Native](https://img.shields.io/badge/Android-Native%20AlarmClock%20%2B%20ForegroundService-3DDC84?logo=android&logoColor=white)](#-المنظومة-الأصلية-للأذان-وشاشة-القفل--native-adhan--azkar-engine)
[![iOS Native](https://img.shields.io/badge/iOS-Time%20Sensitive%20%2B%20SwiftUI%20Extension-000000?logo=apple&logoColor=white)](ios/NATIVE_IOS_SETUP.md)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-success)](#-هيكلية-المشروع--architecture)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blueviolet)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-Waqf%20%2F%20Open%20Source-teal)](#-صدقة-جارية--charity-waqf)

<br/>

> **﴿ وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَىٰ وَاتَّقُونِ يَا أُولِي الْأَلْبَابِ ﴾**  
> *[ سورة البقرة: 197 ]*

</div>

---

## 📌 نبذة عن التطبيق | Overview

**زاد المسلم (Zad Al-Muslim)** هو تطبيق إسلامي متكامل يعمل دون إنترنت لمعظم وظائفه، بُني باستخدام **Flutter** وفق معمارية **Clean Architecture** ونمط **MVVM** عبر **BLoC / Cubit**، مع محرك أصلي (**Native Kotlin & Swift**) لمنبهات الأذان والأذكار التفاعلية على شاشة القفل.

يجمع التطبيق بين الدقة الفلكية، والتصميم الإسلامي الهادئ الخالي من التوهج النيوني، والتفاعل اللمسي (**Haptic Feedback**)، مع توفيره مجاناً بالكامل دون إعلانات أو تتبع كصدقة جارية.

---

## ✨ المميزات الرئيسية | Key Features

### 1. 📖 المصحف الشريف (Holy Quran)
- تلاوة القرآن الكريم كاملاً بالرسم العثماني الأصيل المعتمد.
- فهرس كامل للسور والأجزاء ومحفوظات القراءة السريعة (Bookmarks) والبحث.
- دعم التلاوة المريحة في المظهرين الداكن والنهاري مع الحفاظ الكامل على النص القرآني بالعربية.

### 2. ⏱️ مواقيت الصلاة الفلكية (Accurate Prayer Times)
- حساب فلكي دقيق عبر حزمة `adhan` مبني على إحداثيات GPS أو الاختيار اليدوي للمدن.
- عداد تنازلي للصلاة القادمة مع التاريخ الهجري والميلادي المقترن.

### 3. 📢 المنظومة الأصلية للأذان وشاشة القفل | Native Adhan & Azkar Engine
بدلاً من تشغيل محرك Flutter فوق شاشة القفل وتضارب الصوت، يعتمد التطبيق على **طبقة أصلية معزولة**:
- **على أندرويد (`Android Kotlin`)**:
  - جدولة منبهات الأذان بدقة عبر `AlarmManager.setAlarmClock` لتجاوز قيود السكون العميق (Doze) وواجهات توفير الطاقة (مثل Honor MagicOS / EMUI / MIUI).
  - تشغيل الصوت كاملاً عبر خدمة أمامية مستقلة `AdhanForegroundService` (`FOREGROUND_SERVICE_MEDIA_PLAYBACK` + `AudioAttributes.USAGE_ALARM` + `WakeLock` محدود 4 دقائق) باستخدام ملفات `res/raw/*.mp3` دون انقطاع.
  - واجهة أصلية خفيفة ومعزولة `SanctuaryLockActivity` (`taskAffinity=":sanctuary_lock"`) تضيء فوق شاشة القفل بتصميم السماء المتدرجة والنجمة المثمنة المتنفسة ودعاء ما بعد الأذان (صحيح البخاري 614) مع زر النسخ والانتقال المباشر إلى القبلة أو التطبيق.
  - إعادة جدولة تلقائية عبر `NativeBootReceiver` عند إعادة تشغيل الهاتف أو تغيير الوقت/المنطقة الزمنية أو تحديث التطبيق.
- **على iOS (`Swift & SwiftUI`)**:
  - تنبيهات `Time Sensitive` عبر `UNUserNotificationCenter` مع فئات إجراءات تفاعلية (`ADHAN_CATEGORY` و `AZKAR_CATEGORY`) ودعم ملفات `.caf` (`29s`) وتشغيل الأذان الكامل عبر `AVAudioPlayer` (`UIBackgroundModes: audio`).
  - قوالب واجهة شاشة القفل الموسّعة `ZadNotificationUI` (`UNNotificationContentExtension`) الجاهزة للربط في Xcode على macOS (راجع [ios/NATIVE_IOS_SETUP.md](ios/NATIVE_IOS_SETUP.md)).
- **تنبيه ما قبل الصلاة (5 دقائق)**: إشعار هادئ للاستعداد والوضوء.
- **أصوات مؤذنين متعددة** مع تمييز تلقائي لأذان الفجر:
  - فضيلة الشيخ **عبد الباسط عبد الصمد** (مصر).
  - فضيلة الشيخ **مشاري راشد العفاسي** (الكويت).
  - أذان **الحرم المكي الشريف** بصوت الشيخ **أحمد بن علي ملا** (مكة المكرمة).
- **معاينة فورية وفحص الموثوقية من الإعدادات**: إمكانية اختبار شاشة الأذان وشاشة الأذكار مباشرة من الإعدادات، مع فحص صلاحيات البطارية/المنبه الدقيق/شاشة القفل وإصلاحها بضغطة واحدة.

### 4. 📿 الأذكار اليومية والمسبحة الإلكترونية (Azkar & Lockscreen Companion)
- أذكار الصباح (07:00 ص) والمساء (05:00 م) ومجموعات بعد الصلاة والنوم والأدعية القرآنية.
- **رفيق الأذكار التفاعلي فوق شاشة القفل**: نافذة أصلية تعرض الذكر بالتشكيل والفضل والمصدر مع عدّاد لمسي دائري وتأجيل 30 دقيقة، مع **مزامنة ثنائية الاتجاه** تعكس التسبيحات المنجزة فور فتح Flutter.
- المحافظة الصارمة على النصوص العربية الشريفة للأذكار والأدعية في كلا وضعي اللغة العربية والإنجليزية.

### 5. 🧭 بوصلة القبلة التفاعلية (Interactive Qibla Compass)
- تحديد اتجاه الكعبة المشرفة لحظياً عبر مستشعرات الجهاز مع استجابة لمسية عند المحاذاة.

### 6. 🕌 دليل المساجد القريبة والملاحة (Nearby Mosques & Live Map)
- عرض أقرب المساجد ضمن نطاق (500م، 1كم، 3كم، 5كم) على خريطة `OpenStreetMap` تفاعلية وقائمة مرتبة بالمسافة ووقت الوصول التقريبي وفتح المسار في الخرائط.

### 7. 📚 الأحاديث النبوية الشريفة (Prophetic Hadiths)
- تصفح كتب الحديث المضمنة محلياً (البخاري، مسلم، الأربعون النووية، رياض الصالحين) مع تفاصيل كل حديث.

### 8. 🎨 المظهرين الداكن والفاتح وتعدد اللغات (Theming & Localization)
- دعم كامل للعربية والإنجليزية (`easy_localization`) مع تبديل فوري.
- نظام ألوان دلالي بالكامل عبر `ThemeExtension` و`ColorScheme` دون أي شروط `isDark` داخل الـ Widgets (`Rule 8`).

---

## 🏗️ هيكلية المشروع | Architecture

```text
lib/
├── core/
│   ├── api/                        # إعدادات الشبكة والـ Interceptors
│   ├── config/                     # التهيئة العامة للتطبيق
│   ├── di/                         # حقن الاعتماديات (GetIt Service Locator)
│   ├── localization/               # إدارة اللغات (assets/lang/ar.json & en.json)
│   ├── network/                    # فحص الاتصال بالإنترنت
│   ├── routes/                     # المسارات المركزية (AppRouter & Routes)
│   ├── services/
│   │   ├── native/                 # جسر MethodChannel والمزامنة الثنائية (NativeAlarmBridgeService & NativeSyncCoordinator)
│   │   └── notification/           # جدولة الـ 7 أيام، خدمة الإشعارات، ومجدول الأذكار
│   ├── theme/                      # الثوابت اللونية والخطوط والمظهر التكيفي
│   ├── utils/                      # الثوابت والاهتزازات اللمسية (AppHaptics)
│   └── widgets/                    # المكونات الموحدة (CustomButton, CustomTextField, CustomSwitcherTile, AppDialogs...)
│
├── features/
│   ├── splash/                     # شاشة البداية وتوجيه الإطلاق الفوري من الإشعارات
│   ├── onboarding/                 # الجولة التعريفية بالمميزات
│   ├── home/                       # الشاشة الرئيسية ومواقيت الصلاة الفلكية والتاريخ الهجري
│   ├── quran/                      # تلاوة وفهرس القرآن الكريم
│   ├── adhan/                      # نماذج ومكونات الأذان التراثية
│   ├── qibla/                      # بوصلة تحديد القبلة
│   ├── mosques/                    # خريطة ودليل المساجد القريبة
│   ├── azkar/                      # أذكار المسلم والمزامنة مع رفيق شاشة القفل
│   ├── tasbeeh/                    # السبحة الإلكترونية التفاعلية
│   ├── hadith/                     # الأحاديث النبوية وشروحها
│   └── settings/                   # الإعدادات، المؤذن، الموقع، ومعاينة/موثوقية شاشة القفل
│
└── main.dart                       # نقطة انطلاق التطبيق

android/app/src/main/kotlin/com/example/islamic_app/alarm/
├── NativeScheduleStore.kt          # تخزين JSON للجداول وتحديثات الأذكار والروابط
├── NativeAlarmScheduler.kt         # AlarmClock + Exact Alarms + فحص موثوقية الجهاز
├── AdhanForegroundService.kt       # خدمة تشغيل الأذان المستمرة + AudioFocus + WakeLock
├── Receivers.kt                    # PrayerAlarmReceiver, AzkarAlarmReceiver, NativeBootReceiver
├── SanctuaryDesignTokens.kt        # ألوان وقياسات وInsets التصميم الإسلامي السماوي
├── SanctuaryCanvasViews.kt         # AtmosphericSkyView, BreathingRosetteView, AzkarCounterRingView
├── AdhanLockPresenter.kt           # واجهة الأذان فوق شاشة القفل
├── AzkarLockPresenter.kt           # واجهة الأذكار والعداد اللمسي فوق شاشة القفل
├── SanctuaryLockActivity.kt        # Activity معزولة سريعة الإقلاع فوق شاشة القفل
└── NativeMethodChannelHandler.kt   # مستمع MethodChannel في أندرويد

ios/
├── Runner/AppDelegate.swift        # جسر MethodChannel + Time-Sensitive + AVAudioPlayer + SwiftUI Sheet
├── ZadNotificationUI/              # قالب UNNotificationContentExtension التفاعلي لشاشة القفل
└── NATIVE_IOS_SETUP.md             # خطوات تفعيل Target الإضافة وتحويل مقاطع .caf في Xcode
```

---

## 🛠️ التقنيات والمكتبات المستخدمة | Tech Stack

| المكتبة / التقنية | الإصدار | الاستخدام |
| :--- | :--- | :--- |
| **Flutter / Dart SDK** | `Dart ^3.14.0` | إطار العمل ولغة البرمجة الأساسية |
| **flutter_bloc / bloc** | `^9.1.1` / `^9.2.1` | إدارة الحالة (MVVM / Cubit) |
| **get_it** | `^9.3.0` | حقن الاعتماديات |
| **easy_localization** | `^3.0.8` | التعريب ودعم اللغتين العربية والإنجليزية |
| **flutter_screenutil** | `^5.9.3` | تكييف المقاسات والخطوط عبر الشاشات |
| **adhan** | `^2.0.0+1` | الحساب الفلكي الدقيق لمواقيت الصلاة دون إنترنت |
| **flutter_local_notifications** | `^18.0.1` | طلب أذونات أندرويد وإدارة الإشعارات المرجعية |
| **audioplayers** | `^6.1.0` | الاستماع المسبق لأصوات المؤذنين في الإعدادات |
| **flutter_map / latlong2** | `^7.0.2` / `^0.9.1` | خرائط OpenStreetMap للمساجد القريبة |
| **geolocator / geocoding** | `^14.0.1` / `^5.0.1` | تحديد الإحداثيات الجغرافية والمدينة |
| **quran** | `^1.4.1` | بيانات السور والآيات القرآنية |
| **dio / shared_preferences** | `^5.11.1` / `^2.5.6` | اتصالات الشبكة والتخزين المحلي |

---

## 🚀 البدء والتشغيل والتحقق | Getting Started & Verification

1. **تثبيت الاعتماديات**:
   ```bash
   flutter pub get
   ```
2. **التحليل الساكن والاختبارات**:
   ```bash
   flutter analyze
   flutter test test/native_alarm_bridge_test.dart
   ```
3. **تشغيل التطبيق (Android)**:
   ```bash
   flutter run
   ```
4. **إعداد إضافات iOS على macOS**:
   راجع خطوات Xcode وتحويل مقاطع `.caf` في [ios/NATIVE_IOS_SETUP.md](ios/NATIVE_IOS_SETUP.md).

---

## 🔒 صلاحيات النظام وموثوقية الأذان | System Permissions

يتضمن `AndroidManifest.xml` الصلاحيات اللازمة لعمل المنبهات الدقيقة والشاشة المعزولة:
- `SCHEDULE_EXACT_ALARM` و `USE_EXACT_ALARM`
- `FOREGROUND_SERVICE` و `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
- `USE_FULL_SCREEN_INTENT` و `WAKE_LOCK`
- `POST_NOTIFICATIONS` و `RECEIVE_BOOT_COMPLETED`

> **💡 تنبيه لمستخدمي هواتف Honor (MagicOS) / Huawei / Xiaomi / Samsung**:  
> لضمان عدم تأخير المنبهات أو حجب شاشة القفل، يمكن فحص الحالة وإصلاحها مباشرة من **الإعدادات ← شاشة الأذان على شاشة القفل ← ضبط الصلاحيات**، مع تفعيل **"العمل في الخلفية / بلا قيود"** و**"العرض على شاشة القفل"**.

---

## 📜 صدقة جارية | Charity (Waqf)

هذا التطبيق مجاني بالكامل، خالٍ من أي إعلانات أو تتبع، ومتاح كصدقة جارية عن جميع المسلمين والمسلمات، الأحياء منهم والأموات.

> **«إِذَا مَاتَ الإنْسَانُ انْقَطَعَ عنْه عَمَلُهُ إِلَّا مِن ثَلَاثَةٍ: إِلَّا مِن صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو له»**  
> *[ صحيح مسلم ]*
