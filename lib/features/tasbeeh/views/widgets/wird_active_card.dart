import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/wird_item.dart';
import 'tasbeeh_ticks_painter.dart';

/// Center interactive card for the current active Dhikr in the Daily Wird
class WirdActiveCard extends StatefulWidget {
  final WirdItem item;
  final VoidCallback onTap;

  const WirdActiveCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<WirdActiveCard> createState() => _WirdActiveCardState();
}

class _WirdActiveCardState extends State<WirdActiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isCompleted = widget.item.isCompleted;
    final remaining = widget.item.targetCount - widget.item.currentCount;

    final primaryAccent = isCompleted ? appColors.statusSuccess : appColors.accentGold;

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
                    progress: widget.item.progress,
                    activeColor: primaryAccent,
                    inactiveColor: appColors.cardBorder.withValues(alpha: 0.5),
                  ),
                ),
              ),

              // 2. Continuous Sweep Progress Ring
              SizedBox(
                width: 252.w,
                height: 252.w,
                child: CircularProgressIndicator(
                  value: widget.item.progress,
                  strokeWidth: 5.5.w,
                  backgroundColor: appColors.cardBorder.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
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
                    color: primaryAccent.withValues(alpha: isCompleted ? 0.8 : 0.35),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryAccent.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sacred Arabic Dhikr
                    Text(
                      widget.item.arabicText,
                      textAlign: TextAlign.center,
                      style: AppTypography.quranAyah.copyWith(
                        fontSize: 20.sp,
                        color: primaryAccent,
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
                        color: isCompleted
                            ? appColors.statusSuccess
                            : theme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Gap(4.h),

                    // Status / Remaining Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? appColors.statusSuccess.withValues(alpha: 0.15)
                            : appColors.badgeBackground,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: primaryAccent.withValues(alpha: 0.3),
                          width: 0.6,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCompleted) ...[
                            Icon(
                              Icons.check_circle_rounded,
                              size: 13.sp,
                              color: appColors.statusSuccess,
                            ),
                            Gap(4.w),
                          ],
                          Text(
                            isCompleted
                                ? 'item_completed'.tr()
                                : (remaining > 0
                                    ? 'remaining_count'.tr(namedArgs: {'count': '$remaining'})
                                    : '/ ${widget.item.targetCount}'),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryAccent,
                            ),
                          ),
                        ],
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
