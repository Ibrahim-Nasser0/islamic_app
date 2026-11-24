import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';

class AdhanActionsBar extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onStopAdhan;
  final VoidCallback onClose;

  const AdhanActionsBar({
    super.key,
    required this.isPlaying,
    required this.onStopAdhan,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 0.8.w,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPrimaryActionButton(context),
          SizedBox(height: 10.h),
          _buildSecondaryActions(context),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context) {
    if (isPlaying) {
      return CustomButton(
        text: 'stop_adhan'.tr(),
        icon: Icons.volume_off_rounded,
        color: const Color(0xFFEF4444),
        height: 52.h,
        borderRadius: 24,
        onPressed: () {
          AppHaptics.medium();
          onStopAdhan();
        },
      ).buttonAnimation();
    }

    return CustomButton(
      text: 'prayer_completed'.tr(),
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF10B981),
      height: 52.h,
      borderRadius: 24,
      onPressed: () {
        AppHaptics.medium();
        onClose();
      },
    ).buttonAnimation();
  }

  Widget _buildSecondaryActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomButton(
            text: 'qibla_direction'.tr(),
            icon: Icons.explore_rounded,
            isOutlined: true,
            color: const Color(0xFFFFD54F),
            height: 44.h,
            borderRadius: 20,
            onPressed: () {
              AppHaptics.light();
              Navigator.pushNamed(context, Routes.qibla);
            },
          ).buttonAnimation(),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 2,
          child: CustomButton(
            text: 'dismiss'.tr(),
            icon: Icons.close_rounded,
            isOutlined: true,
            color: Colors.white.withValues(alpha: 0.8),
            height: 44.h,
            borderRadius: 20,
            onPressed: () {
              AppHaptics.light();
              onClose();
            },
          ).buttonAnimation(),
        ),
      ],
    );
  }
}
