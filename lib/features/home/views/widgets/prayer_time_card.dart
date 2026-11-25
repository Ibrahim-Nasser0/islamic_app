import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/prayer_time_entry.dart';
import 'home_staggered_entry.dart';
import 'prayer_card_status_pill.dart';

/// Celestial Sanctuary prayer card showing icon medallion, prayer name, split time, and status.
class PrayerTimeCard extends StatelessWidget {
  final PrayerTimeEntry prayer;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isNext = prayer.isNext;
    final isPast = prayer.isPast;
    final locale = context.locale.languageCode;

    final digits = DateFormat('h:mm', locale).format(prayer.time);
    final period = DateFormat('a', locale).format(prayer.time);
    final prayerName = locale == 'ar' ? prayer.nameAr : prayer.nameEn;

    final cardColor = isNext
        ? null
        : (isPast
            ? appColors.surfaceSubtle.withValues(alpha: 0.72)
            : theme.colorScheme.surface);

    return TactilePressScale(
      builder: (context, onHighlight) => Material(
        color: Colors.transparent,
        child: InkWell(
          onHighlightChanged: onHighlight,
          onTap: () {
            AppHaptics.selection();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(17.r),
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: width ?? 94.w,
          constraints: BoxConstraints(minHeight: height ?? 112.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            gradient: isNext
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appColors.emeraldBevelTop,
                      appColors.emeraldBevelBottom,
                    ],
                  )
                : null,
            color: cardColor,
            border: Border.all(
              color: isNext
                  ? appColors.accentGold.withValues(alpha: 0.65)
                  : (isPast
                      ? appColors.cardBorder.withValues(alpha: 0.55)
                      : appColors.cardBorder),
              width: isNext ? 1.1 : 0.85,
            ),
            boxShadow: isNext
                ? [
                    BoxShadow(
                      color: appColors.emeraldBevelBottom.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : (isPast ? null : appColors.cardShadow),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.r),
            child: Stack(
              children: [
                if (isNext)
                  PositionedDirectional(
                    top: -10.h,
                    end: -10.w,
                    child: Opacity(
                      opacity: 0.08,
                      child: RubElHizbMark(
                        size: 46.w,
                        color: AppColors.accentLight,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OctagonalIconFrame(
                        size: 30,
                        active: isNext,
                        child: Icon(
                          prayer.icon,
                          size: 14.sp,
                          color: isNext
                              ? AppColors.accentLight
                              : (isPast
                                  ? appColors.textMuted
                                  : appColors.accentGold),
                        ),
                      ),
                      Gap(6.h),
                      Column(
                        children: [
                          Text(
                            prayerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                              color: isNext
                                  ? AppColors.quranPage
                                  : (isPast
                                      ? appColors.textMuted
                                      : theme.colorScheme.onSurface),
                            ),
                          ),
                          Gap(1.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  digits,
                                  style: TextStyle(
                                    fontSize: isNext ? 15.5.sp : 14.5.sp,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                    color: isNext
                                        ? AppColors.quranPage
                                        : (isPast
                                            ? appColors.textMuted
                                            : theme.colorScheme.onSurface),
                                  ),
                                ),
                                Gap(2.5.w),
                                Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isNext
                                        ? AppColors.accentLight
                                        : appColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(6.h),
                      PrayerCardStatusPill(status: prayer.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
