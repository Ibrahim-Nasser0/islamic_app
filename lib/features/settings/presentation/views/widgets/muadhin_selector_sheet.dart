import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/theme/typography.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:material_ui/material_ui.dart';


import '../../models/muadhin_option.dart';

class MuadhinSelectorSheet extends StatelessWidget {
  final String selectedId;
  final ValueChanged<MuadhinOption> onSelect;

  const MuadhinSelectorSheet({
    super.key,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  FlutterIslamicIcons.solidPrayer,
                  color: appColors.accentGold,
                  size: 22.sp,
                ),
                Gap(10.w),
                Text(
                  'select_muadhin'.tr(),
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              'selected_muadhin_subtitle'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: appColors.textMuted,
              ),
            ),
            Gap(16.h),
            ...MuadhinOption.defaultList.map((option) {
              final isSelected = option.id == selectedId;

              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? appColors.accentGold.withValues(alpha: 0.6)
                        : appColors.cardBorder,
                    width: isSelected ? 1.2 : 0.8,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppHaptics.selection();
                      onSelect(option);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(14.r),
                    child: Padding(
                      padding: EdgeInsets.all(14.r),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.accentGold.withValues(alpha: 0.15)
                                  : appColors.surfaceSubtle,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volume_up_rounded,
                              size: 18.sp,
                              color: isSelected
                                  ? appColors.accentGold
                                  : appColors.textMuted,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.nameKey.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Gap(2.h),
                                Text(
                                  option.location,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: appColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: appColors.accentGold,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
