import 'package:material_ui/material_ui.dart';
import 'routes.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/onboarding/presentation/views/on_boarding_view.dart';
import '../../features/qibla/views/qibla_screen.dart';
import '../../features/quran/views/quran_reader_screen.dart';
import '../../features/azkar/views/azkar_category_screen.dart';
import '../../features/hadith/domain/entities/hadith_item.dart';
import '../../features/hadith/views/hadith_detail_screen.dart';
import '../../features/hadith/views/hadith_list_screen.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/tasbeeh/views/tasbeeh_screen.dart';

/// Application Router
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case Routes.onboarding:
        return _buildRoute(const OnBoardingView(), settings);
      case Routes.home:
        return _buildRoute(const HomeScreen(), settings);
      case Routes.settings:
        return _buildRoute(const SettingsScreen(), settings);
      case Routes.qibla:
        return _buildRoute(const QiblaScreen(), settings);
      case Routes.tasbeeh:
        return _buildRoute(const TasbeehScreen(), settings);
      case Routes.quranReader:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final surahNum = args['surahNumber'] as int? ?? 1;
        final initialAyah = args['initialAyah'] as int? ?? 1;
        return _buildRoute(
          QuranReaderScreen(
            initialSurahNumber: surahNum,
            initialAyah: initialAyah,
          ),
          settings,
        );
      case Routes.azkarCategory:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final categoryId = args['categoryId'] as String? ?? 'morning';
        return _buildRoute(
          AzkarCategoryScreen(categoryId: categoryId),
          settings,
        );
      case Routes.hadithReader:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bookId = args['bookId'] as String? ?? 'nawawi';
        final bookTitle = args['bookTitle'] as String? ?? 'الأربعون النووية';
        return _buildRoute(
          HadithListScreen(bookId: bookId, bookTitle: bookTitle),
          settings,
        );
      case Routes.hadithDetail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final hadith = args['hadith'] as HadithItem;
        return _buildRoute(
          HadithDetailScreen(hadith: hadith),
          settings,
        );
      default:
        return _buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
    } else {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
