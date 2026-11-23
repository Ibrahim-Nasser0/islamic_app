import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Micro-status chip with pulsating neon indicator for Error states
class FailureStatusChip extends StatelessWidget {
  final String label;
  final Color accentColor;
  final bool isCompact;

  const FailureStatusChip({
    super.key,
    required this.label,
    required this.accentColor,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 9.w : 13.w,
        vertical: isCompact ? 3.h : 5.h,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: accentColor.withOpacity(isDark ? 0.40 : 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isCompact ? 5.5.r : 7.r,
            height: isCompact ? 5.5.r : 7.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.8),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(begin: 0.35, end: 1.0, duration: 800.ms),
          Gap(isCompact ? 5.w : 7.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontSize: isCompact ? 9.5.sp : 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
