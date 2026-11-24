import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import '../../utils/extensions.dart';
import 'rub_el_hizb_mark.dart';

/// Gold fading horizontal hairline centered on a Rub el-Hizb ornament.
class GoldHairlineDivider extends StatelessWidget {
  final double jewelSize;
  final double verticalPadding;

  const GoldHairlineDivider({
    super.key,
    this.jewelSize = 14,
    this.verticalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.accentGold;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    gold.withValues(alpha: 0.42),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: RubElHizbMark(
              size: jewelSize.w,
              color: gold.withValues(alpha: 0.85),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gold.withValues(alpha: 0.42),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
