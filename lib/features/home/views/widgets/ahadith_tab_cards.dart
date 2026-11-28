import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Interactive Hadith collection book tile.
class HadithBookTile extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String countLabel;
  final ThemeData theme;
  final AppThemeColors appColors;

  const HadithBookTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.countLabel,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppHaptics.light();
            AppRouter.navigateTo(
              context,
              Routes.hadithReader,
              arguments: {'bookId': id, 'bookTitle': title},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                OctagonalIconFrame(
                  size: 44,
                  child: Icon(
                    FlutterIslamicIcons.solidMohammad,
                    color: appColors.accentGold,
                    size: 19.sp,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                Text(
                  countLabel,
                  style: TextStyle(fontSize: 11.sp, color: appColors.accentGold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
