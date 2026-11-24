import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/widgets/custom_filter_dropdown.dart';
import 'package:material_ui/material_ui.dart';

import '../../cubit/settings_cubit.dart';

import 'settings_icon_badge.dart';

class SettingsLanguageCard extends StatelessWidget {
  const SettingsLanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Row(
        children: [
          const SettingsIconBadge(icon: Icons.language_rounded),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_language'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Gap(2.h),
                Text(
                  'app_language_desc'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: appColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          CustomFilterDropdown<String>(
            selectedValue: context.locale.languageCode,
            items: const [
              CustomFilterDropdownItem(
                value: 'ar',
                label: 'العربية',
              ),
              CustomFilterDropdownItem(
                value: 'en',
                label: 'English',
              ),
            ],
            onSelected: (code) {
              try {
                context.read<SettingsCubit>().setLanguageCode(code);
              } catch (_) {}
              context.setLocale(Locale(code));
            },
          ),
        ],
      ),
    );
  }
}
