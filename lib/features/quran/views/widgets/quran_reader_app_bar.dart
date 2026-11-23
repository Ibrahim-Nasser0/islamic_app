import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';

/// App Bar for Quran Reader with title and font size scaling controls
class QuranReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final bool isContinuousMode;
  final VoidCallback onToggleMode;
  final VoidCallback onIncreaseFont;
  final VoidCallback onDecreaseFont;

  const QuranReaderAppBar({
    super.key,
    required this.title,
    required this.fontSize,
    required this.isContinuousMode,
    required this.onToggleMode,
    required this.onIncreaseFont,
    required this.onDecreaseFont,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: AppTypography.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        // Reading Mode Toggle
        IconButton(
          tooltip: isContinuousMode ? 'عرض الآيات' : 'عرض المصحف',
          icon: Icon(
            isContinuousMode ? Icons.view_headline_rounded : Icons.auto_stories_rounded,
            size: 21.sp,
            color: appColors.accentGold,
          ),
          onPressed: () {
            AppHaptics.light();
            onToggleMode();
          },
        ),

        // Font Size Adjuster Pill
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: appColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: appColors.cardBorder, width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  AppHaptics.selection();
                  onDecreaseFont();
                },
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Text(
                    'A-',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.textMuted,
                    ),
                  ),
                ),
              ),
              Gap(2.w),
              InkWell(
                onTap: () {
                  AppHaptics.selection();
                  onIncreaseFont();
                },
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Text(
                    'A+',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.accentGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
