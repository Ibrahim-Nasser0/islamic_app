import 'dart:ui';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../utils/extensions.dart';
import '../../islamic/gold_hairline_divider.dart';
import '../../islamic/manuscript_corners.dart';

/// Celestial Sanctuary frosted vessel shared across all application dialogs.
class DialogFrostedVessel extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const DialogFrostedVessel({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 340.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.97),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: appColors.accentGold.withValues(alpha: 0.28),
                width: 1.0,
              ),
              boxShadow: appColors.cardShadow,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GoldHairlineDivider(jewelSize: 10),
                    Padding(
                      padding: padding ??
                          EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                      child: child,
                    ),
                  ],
                ),
                ManuscriptCorners(
                  inset: 9,
                  length: 10,
                  color: appColors.accentGold.withValues(alpha: 0.42),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1.0, 1.0),
          duration: 240.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 200.ms);
  }
}
