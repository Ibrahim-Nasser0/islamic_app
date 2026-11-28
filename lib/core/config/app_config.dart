/// Application Configuration
class AppConfig {
  AppConfig._();

  static const String appName = 'زاد المسلم';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Developer Info
  static const String developerName = 'Ibrahim Nasser';
  static const String developerGithub = 'https://github.com/Ibrahim-Nasser0';
  static const String developerProfile = 'ibrahim-nasser.vercel.app';
  static const String developerLinkedIn =
      'https://www.linkedin.com/in/ibrahim-nasser0';
  static const String developerEmail = 'ibrahimnasser.mobile@gmail.com';

  // Content & Audio Attribution
  static const String adhanAudioSourceName = 'islamweb.net';
  static const String adhanAudioSourceUrl = 'https://www.islamweb.net';

  // Environment
  static const bool isProduction = false;
  static const bool enableLogging = true;

  // API Configuration
  static String get baseUrl {
    return isProduction
        ? 'https://api.production.com'
        : 'https://api.development.com';
  }
}
