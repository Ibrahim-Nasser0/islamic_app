import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../features/onboarding/presentation/models/page_view_item_model.dart';

/// Application Constants
/// Centralized constant definitions
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingKey = 'onboarding_completed';
  static const String prayerNotificationKey = 'prayer_notifications';
  static const String prePrayerNotificationKey = 'pre_prayer_notifications';
  static const String azkarNotificationKey = 'azkar_notifications';
  static const String athanSoundKey = 'athan_sound';
  static const String adhanLockscreenKey = 'adhan_lockscreen_enabled';
  static const String muadhinVoiceKey = 'muadhin_voice';
  static const String isManualLocationKey = 'is_manual_location';
  static const String customLocationLatKey = 'custom_location_lat';
  static const String customLocationLngKey = 'custom_location_lng';
  static const String customLocationNameArKey = 'custom_location_name_ar';
  static const String customLocationNameEnKey = 'custom_location_name_en';
  static const String dailyWirdCountKey = 'daily_wird_ayah_count';
  static const String dailyWirdCursorKey = 'daily_wird_cursor_ayah';
  static const String dailyWirdCompletedDateKey = 'daily_wird_completed_date';
  static const String dailyWirdCursorCompletedKey = 'daily_wird_cursor_completed';
  static const String dailyWirdLastBatchEndKey = 'daily_wird_last_batch_end';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 999.0;

  // Icon Sizes
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  // Image Sizes
  static const double avatarSizeSM = 32.0;
  static const double avatarSizeMD = 48.0;
  static const double avatarSizeLG = 64.0;
  static const double avatarSizeXL = 96.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx'];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'No internet connection. Please check your network.';
  static const String timeoutErrorMessage =
      'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please login again.';

  // Onboarding Pages
  static List<PageViewItemModel> onBoardingPages(BuildContext context) {
    return [
      PageViewItemModel(
        icon: FlutterIslamicIcons.solidPrayer,
        badgeText: 'onboarding_badge_1'.tr(),
        title: 'onboarding_title_1'.tr(),
        subtitle: 'onboarding_subtitle_1'.tr(),
        featureTags: const ['دقة جغرافية', 'تنبيهات الأذان', 'اتجاه القبلة'],
      ),
      PageViewItemModel(
        icon: FlutterIslamicIcons.solidQuran2,
        badgeText: 'onboarding_badge_2'.tr(),
        title: 'onboarding_title_2'.tr(),
        subtitle: 'onboarding_subtitle_2'.tr(),
        featureTags: const ['رسم عثماني', 'فهرس الأجزاء والسور', 'علامات مرجعية'],
      ),
      PageViewItemModel(
        icon: FlutterIslamicIcons.solidTasbih,
        badgeText: 'onboarding_badge_3'.tr(),
        title: 'onboarding_title_3'.tr(),
        subtitle: 'onboarding_subtitle_3'.tr(),
        featureTags: const ['حصن المسلم', 'مسبحة ذكية', 'أوراد يومية'],
      ),
      PageViewItemModel(
        icon: FlutterIslamicIcons.solidMohammad,
        badgeText: 'onboarding_badge_4'.tr(),
        title: 'onboarding_title_4'.tr(),
        subtitle: 'onboarding_subtitle_4'.tr(),
        featureTags: const ['الأربعون النووية', 'صحيح البخاري ومسلم', 'رياض الصالحين'],
      ),
      PageViewItemModel(
        icon: Icons.verified_user_rounded,
        badgeText: 'onboarding_badge_5'.tr(),
        title: 'onboarding_title_5'.tr(),
        subtitle: 'onboarding_subtitle_5'.tr(),
        isPermissionsStep: true,
      ),
    ];
  }
}
