import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Illuminated Manuscript top header strip for [DailyHadithHighlightCard].
class DailyHadithCardHeader extends StatelessWidget {
  final String? bookStamp;
  final VoidCallback onShuffle;

  const DailyHadithCardHeader({
    super.key,
    required this.bookStamp,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: appColors.accentGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.vertical(top: Radius.circular(17.r)),
      ),
      child: Row(
        children: [
          RubElHizbMark(size: 15.w, color: appColors.accentGold),
          Gap(8.w),
          Flexible(
            child: Text(
              'hadith_of_the_day'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: appColors.accentGold,
              ),
            ),
          ),

          Gap(8.w),
          if (bookStamp != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  bookStamp!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: appColors.accentGold,
                  ),
                ),
              ),
            ),

          const Spacer(),
          Gap(15.w),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () {
                AppHaptics.selection();
                onShuffle();
              },
              borderRadius: BorderRadius.circular(999.r),
              child: Tooltip(
                message: 'hadith_shuffle_tooltip'.tr(),
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.accentGold.withValues(alpha: 0.14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.autorenew_rounded,
                    size: 16.sp,
                    color: appColors.accentGold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
