import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routes/routes.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/utils/extensions.dart';
import '../../core/di/injection_container.dart' as di;
import '../../core/services/notification/notification_service.dart';

/// Royal Islamic Splash Screen featuring sacred medallion emblem & verse animation
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

  void _navigateToNext() {
    final pending = di.sl<NotificationService>().consumePendingPayload();
    if (pending != null && pending.startsWith('adhan:')) {
      Navigator.pushReplacementNamed(context, Routes.home);
      Navigator.pushNamed(context, Routes.adhan, arguments: pending);
      return;
    }
    if (pending != null && pending.startsWith('azkar:')) {
      final categoryId = pending.split(':')[1];
      Navigator.pushReplacementNamed(context, Routes.home);
      Navigator.pushNamed(
        context,
        Routes.azkarCategory,
        arguments: {'categoryId': categoryId},
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2620), Color(0xFF133B31), Color(0xFF0C1915)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              _buildCentralEmblem(appColors),
              Gap(28.h),
              Text(
                'app_name'.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.h1.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2),
              Gap(12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  'splash_verse'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTypography.quranAyah.copyWith(
                    fontSize: 17.sp,
                    color: appColors.accentGold,
                    height: 1.8,
                  ),
                ),
              ).animate().fade(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
              const Spacer(flex: 4),
              _buildDotsIndicator(appColors),
              Gap(20.h),
              Text(
                'app_version'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCentralEmblem(dynamic appColors) {
    return Container(
      width: 130.w,
      height: 130.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(color: appColors.accentGold.withValues(alpha: 0.45), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: appColors.accentGold.withValues(alpha: 0.2),
            blurRadius: 36,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 95.w,
          height: 95.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E4F), Color(0xFF13453A)],
            ),
            border: Border.all(color: appColors.accentGold.withValues(alpha: 0.3), width: 1.0),
          ),
          child: Icon(Icons.mosque_rounded, size: 46.sp, color: appColors.accentGold),
        ),
      ),
    ).animate().scale(begin: const Offset(0.75, 0.75), duration: 700.ms, curve: Curves.easeOutBack).fadeIn(duration: 600.ms);
  }

  Widget _buildDotsIndicator(dynamic appColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColors.accentGold.withValues(alpha: 0.7),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(delay: Duration(milliseconds: index * 180), duration: 600.ms, begin: const Offset(0.6, 0.6), end: const Offset(1.2, 1.2));
      }),
    );
  }
}
