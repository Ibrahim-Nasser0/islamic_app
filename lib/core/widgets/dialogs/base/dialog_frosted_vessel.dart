import 'dart:ui';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';

/// Apple-grade frosted glass vessel container ensuring 100% visual consistency
/// across all application dialogs (Loading, Success, Failure, Confirm).
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
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 340.w),
            padding: padding ?? EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: appColors.cardBorder,
                width: 1.0,
              ),
              boxShadow: appColors.cardShadow,
            ),
            child: child,
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1.0, 1.0),
          duration: 260.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 220.ms);
  }
}
