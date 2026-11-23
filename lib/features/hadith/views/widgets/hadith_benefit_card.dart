import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';

class HadithBenefitCard extends StatelessWidget {
  final String benefit;

  const HadithBenefitCard({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: appColors.accentGold,
                size: 18.sp,
              ),
              Gap(8.w),
              Text(
                'من فوائد الحديث والعمل به',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            benefit,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.6,
              color: appColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
