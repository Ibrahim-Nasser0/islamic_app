import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/di/injection_container.dart' as di;
import '../../core/routes/routes.dart';
import '../../core/services/native/native_sync_coordinator.dart';
import '../../core/services/notification/notification_service.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/widgets.dart';
import '../settings/data/datasources/settings_local_data_source.dart';

/// Royal Islamic Splash Screen aligned with Celestial Obsidian sanctuary.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    try {
      final nativeRoute = await di
          .sl<NativeSyncCoordinator>()
          .consumeInitialLaunchRoute()
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      if (nativeRoute != null && mounted) {
        final route = nativeRoute['route'] as String;
        final args = nativeRoute['args'] as Map<String, dynamic>?;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, Routes.home);
          if (route != Routes.home) Navigator.pushNamed(context, route, arguments: args);
        });
        return;
      }

      final pending = di.sl<NotificationService>().consumePendingPayload();
      if (pending != null &&
          (pending.startsWith('adhan:') || pending.startsWith('pre:'))) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pushReplacementNamed(context, Routes.home);
        });
        return;
      }
      if (pending != null && pending.startsWith('azkar:')) {
        final parts = pending.split(':');
        final categoryId = parts.length > 1 ? parts[1] : 'morning';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, Routes.home);
          Navigator.pushNamed(context, Routes.azkarCategory, arguments: {'categoryId': categoryId});
        });
        return;
      }
    } catch (e) {
      debugPrint('SplashScreen: error resolving pending launch route: $e');
    }

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final completed = di.sl<SettingsLocalDataSource>().hasCompletedOnboarding();
      Navigator.pushReplacementNamed(context, completed ? Routes.home : Routes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.accentGold;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF060E0B), Color(0xFF0D1D17), Color(0xFF07100D)],
          ),
        ),
        child: Stack(
          children: [
            ManuscriptCorners(color: AppColors.secondaryLight.withValues(alpha: 0.45)),
            SafeArea(
              child: Column(
                children: [
                  Gap(16.h),
                  _buildBasmalaFrieze(gold),
                  const Spacer(flex: 3),
                  OctagonalIconFrame(
                    size: 120,
                    active: true,
                    child: Icon(Icons.mosque_rounded, size: 48.sp, color: gold),
                  )
                      .animate()
                      .scale(begin: const Offset(0.78, 0.78), duration: 700.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 600.ms),
                  Gap(28.h),
                  Text(
                    'app_name'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTypography.quranAyah.copyWith(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkPrimary,
                      height: 1.3,
                    ),
                  ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2),
                  Gap(10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      'splash_verse'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTypography.quranAyah.copyWith(fontSize: 17.sp, color: gold, height: 1.8),
                    ),
                  ).animate().fade(duration: 600.ms, delay: 350.ms).slideY(begin: 0.2),
                  const Spacer(flex: 4),
                  _buildDotsIndicator(gold),
                  Gap(18.h),
                  Text(
                    'app_version'.tr(),
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textDarkPrimary.withValues(alpha: 0.45)),
                  ),
                  Gap(16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasmalaFrieze(Color gold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RubElHizbMark(size: 11.w, color: gold.withValues(alpha: 0.7)),
        Gap(8.w),
        Text(
          'basmala_short'.tr(),
          style: AppTypography.quranAyah.copyWith(
            fontSize: 13.sp,
            color: gold.withValues(alpha: 0.85),
            height: 1.3,
          ),
        ),
        Gap(8.w),
        RubElHizbMark(size: 11.w, color: gold.withValues(alpha: 0.7)),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildDotsIndicator(Color gold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: gold.withValues(alpha: 0.7)),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              delay: Duration(milliseconds: index * 180),
              duration: 600.ms,
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.2, 1.2),
            );
      }),
    );
  }
}
