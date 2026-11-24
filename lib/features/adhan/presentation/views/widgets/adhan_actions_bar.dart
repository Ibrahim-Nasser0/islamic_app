import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/../../../core/routes/routes.dart';
import '/../../../core/utils/haptics.dart';
import '/../../../core/widgets/animations/button_animation.dart';
import '/../../../core/widgets/custom_button.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPrimaryActionButton(context),
          SizedBox(height: 12.h),
          _buildSecondaryActions(context),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context) {
    if (isPlaying) {
      return CustomButton(
        text: 'stop_adhan'.tr(),
        icon: Icons.stop_rounded,
        color: const Color(0xFFEF4444),
        onPressed: () {
          AppHaptics.medium();
          onStopAdhan();
        },
      ).buttonAnimation();
    }

    return CustomButton(
      text: 'prayer_completed'.tr(),
      icon: Icons.check_circle_outline_rounded,
      color: const Color(0xFF10B981),
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
          child: CustomButton(
            text: 'qibla_direction'.tr(),
            icon: Icons.explore_rounded,
            isOutlined: true,
            color: Colors.white,
            height: 48.h,
            onPressed: () {
              AppHaptics.light();
              Navigator.pushNamed(context, Routes.qibla);
            },
          ).buttonAnimation(),
        ),
        if (isPlaying) ...[
          SizedBox(width: 12.w),
          Expanded(
            child: CustomButton(
              text: 'dismiss'.tr(),
              icon: Icons.close_rounded,
              isOutlined: true,
              color: Colors.white.withValues(alpha: 0.85),
              height: 48.h,
              onPressed: () {
                AppHaptics.light();
                onClose();
              },
            ).buttonAnimation(),
          ),
        ],
      ],
    );
  }
}
