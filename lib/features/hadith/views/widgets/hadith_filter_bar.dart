import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_filter_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/hadith_item.dart';

/// Search bar + authenticity grade [CustomFilterDropdown] for Hadith books.
class HadithFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedGrade;
  final int totalCount;
  final bool showGradeFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onGradeSelected;

  const HadithFilterBar({
    super.key,
    required this.controller,
    required this.selectedGrade,
    required this.totalCount,
    required this.showGradeFilter,
    required this.onSearchChanged,
    required this.onGradeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Column(
        children: [
          CustomTextField(
            controller: controller,
            hint: 'ابحث برقم الحديث أو الكلمة...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: appColors.textMuted,
              size: 20.sp,
            ),
            onChanged: onSearchChanged,
          ),
          Gap(8.h),
          Row(
            children: [
              Text(
                'hadiths_count'.tr(namedArgs: {'count': '$totalCount'}),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.textMuted,
                ),
              ),
              const Spacer(),
              if (showGradeFilter)
                CustomFilterDropdown<String?>(
                  selectedValue: selectedGrade,
                  onSelected: onGradeSelected,
                  trigger: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(
                        color: appColors.cardBorder,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 14.sp,
                          color: theme.colorScheme.primary,
                        ),
                        Gap(6.w),
                        Text(
                          _labelForTier(selectedGrade).tr(),
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Gap(4.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16.sp,
                          color: appColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                  items: [
                    CustomFilterDropdownItem<String?>(
                      value: null,
                      label: 'hadith_grade_all'.tr(),
                      icon: Icons.apps_rounded,
                    ),
                    CustomFilterDropdownItem<String?>(
                      value: HadithItem.tierMuttafaq,
                      label: 'hadith_grade_muttafaq'.tr(),
                      icon: Icons.verified_rounded,
                    ),
                    CustomFilterDropdownItem<String?>(
                      value: HadithItem.tierSahih,
                      label: 'hadith_grade_sahih'.tr(),
                      icon: Icons.verified_outlined,
                    ),
                    CustomFilterDropdownItem<String?>(
                      value: HadithItem.tierHasanSahih,
                      label: 'hadith_grade_hasan_sahih'.tr(),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    CustomFilterDropdownItem<String?>(
                      value: HadithItem.tierHasan,
                      label: 'hadith_grade_hasan'.tr(),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    CustomFilterDropdownItem<String?>(
                      value: HadithItem.tierCitationInText,
                      label: 'hadith_grade_needs_verification'.tr(),
                      icon: Icons.menu_book_rounded,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _labelForTier(String? tier) => switch (tier) {
        HadithItem.tierMuttafaq => 'hadith_grade_muttafaq',
        HadithItem.tierSahih => 'hadith_grade_sahih',
        HadithItem.tierHasanSahih => 'hadith_grade_hasan_sahih',
        HadithItem.tierHasan => 'hadith_grade_hasan',
        HadithItem.tierCitationInText => 'hadith_grade_needs_verification',
        _ => 'hadith_grade_all',
      };
}
