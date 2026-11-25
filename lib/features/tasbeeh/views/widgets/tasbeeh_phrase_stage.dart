import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/widgets.dart';

/// Tranquil manuscript header card displaying the full sacred Arabic Dhikr
/// above the astrolabe dial so long phrases never truncate inside the circle.
class TasbeehPhraseStage extends StatelessWidget {
  final String arabicText;
  final String? virtueText;
  final bool highlighted;

  const TasbeehPhraseStage({
    super.key,
    required this.arabicText,
    this.virtueText,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: highlighted
                ? appColors.statusSuccess.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: highlighted
                  ? appColors.statusSuccess.withValues(alpha: 0.45)
                  : appColors.accentGold.withValues(alpha: 0.30),
              width: 0.9,
            ),
            boxShadow: appColors.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                arabicText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 20.sp.clamp(17.0, 24.0),
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              if (virtueText != null && virtueText!.isNotEmpty) ...[
                Gap(6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RubElHizbMark(size: 9.w, color: appColors.accentGold),
                    Gap(6.w),
                    Flexible(
                      child: Text(
                        virtueText!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: appColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const ManuscriptCorners(inset: 7, length: 9),
      ],
    );
  }
}
