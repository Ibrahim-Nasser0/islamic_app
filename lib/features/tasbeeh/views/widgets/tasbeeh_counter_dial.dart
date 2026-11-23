import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/tasbeeh_item.dart';
import 'tasbeeh_ticks_painter.dart';

/// Large tactile circular dial displaying live count, Arabic Dhikr, and progress
class TasbeehCounterDial extends StatefulWidget {
  final TasbeehItem item;
  final int target;
  final double progress;
  final VoidCallback onTap;

  const TasbeehCounterDial({
    super.key,
    required this.item,
    required this.target,
    required this.progress,
    required this.onTap,
  });

  @override
  State<TasbeehCounterDial> createState() => _TasbeehCounterDialState();
}

class _TasbeehCounterDialState extends State<TasbeehCounterDial> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final targetText =
        widget.target > 0 ? '/ ${widget.target}' : 'open_target'.tr();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 275.w,
          height: 275.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Astrolabe Bead Ticks Perimeter
              Positioned.fill(
                child: CustomPaint(
                  painter: TasbeehTicksPainter(
                    progress: widget.progress.clamp(0.0, 1.0),
                    activeColor: appColors.accentGold,
                    inactiveColor: appColors.cardBorder.withValues(alpha: 0.5),
                  ),
                ),
              ),

              // 2. Outer Progress Ring
              SizedBox(
                width: 252.w,
                height: 252.w,
                child: CircularProgressIndicator(
                  value: widget.progress.clamp(0.0, 1.0),
                  strokeWidth: 5.5.w,
                  backgroundColor: appColors.cardBorder.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation<Color>(appColors.accentGold),
                  strokeCap: StrokeCap.round,
                ),
              ),

              // 3. Central Tactile Bead Body
              Container(
                width: 226.w,
                height: 226.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.accentGold.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sacred Dhikr Phrase
                    Text(
                      widget.item.arabicText,
                      textAlign: TextAlign.center,
                      style: AppTypography.quranAyah.copyWith(
                        fontSize: 20.sp,
                        color: appColors.accentGold,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(6.h),

                    // Big Number Count
                    Text(
                      '${widget.item.currentCount}',
                      style: AppTypography.h1.copyWith(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Gap(4.h),

                    // Target Indicator Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: appColors.badgeBackground,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: appColors.accentGold.withValues(alpha: 0.3),
                          width: 0.6,
                        ),
                      ),
                      child: Text(
                        targetText,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                          color: appColors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
