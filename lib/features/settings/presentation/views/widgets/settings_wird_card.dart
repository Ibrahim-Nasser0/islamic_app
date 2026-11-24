import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import 'package:islamic_app/core/utils/dialogs.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/widgets.dart';
import 'package:islamic_app/features/quran/presentation/cubit/daily_wird_cubit.dart';
import 'package:islamic_app/features/quran/presentation/cubit/daily_wird_state.dart';

/// Settings card configuring the consecutive Daily Quran Wird ayah count.
class SettingsWirdCard extends StatelessWidget {
  const SettingsWirdCard({super.key});

  static const List<int> _presets = [3, 5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<DailyWirdCubit, DailyWirdState>(
      builder: (context, state) {
        final cubit = context.read<DailyWirdCubit>();
        final count = state.dailyCount;
        final first = state.slice?.verses.first;

        return Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: appColors.cardBorder, width: 0.8),
            boxShadow: appColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  OctagonalIconFrame(
                    size: 40,
                    active: true,
                    child: Icon(FlutterIslamicIcons.solidQuran2, size: 18.sp, color: appColors.accentGold),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('settings_wird_title'.tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                        Text('settings_wird_subtitle'.tr(), style: TextStyle(fontSize: 11.sp, color: appColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(12.h),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: _presets.map((p) {
                        final selected = count == p;
                        return InkWell(
                          onTap: () {
                            AppHaptics.selection();
                            cubit.setDailyCount(p);
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: selected ? appColors.navActivePillBg : appColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: selected ? appColors.accentGold : appColors.cardBorder,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '$p',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: selected ? appColors.accentGold : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  _StepButton(
                    icon: Icons.remove_rounded,
                    onTap: count > 1
                        ? () {
                            AppHaptics.selection();
                            cubit.setDailyCount(count - 1);
                          }
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      count == 1
                          ? 'settings_wird_ayah_single'.tr()
                          : 'settings_wird_ayahs'.tr(namedArgs: {'count': '$count'}),
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: appColors.accentGold),
                    ),
                  ),
                  _StepButton(
                    icon: Icons.add_rounded,
                    onTap: count < 50
                        ? () {
                            AppHaptics.selection();
                            cubit.setDailyCount(count + 1);
                          }
                        : null,
                  ),
                ],
              ),
              if (first != null) ...[
                Gap(10.h),
                Divider(color: appColors.cardBorder, height: 1),
                Gap(8.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'settings_wird_current_pos'.tr(namedArgs: {
                          'surah': first.surahNameAr,
                          'ayah': '${first.ayahNumber}',
                        }),
                        style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        AppHaptics.heavy();
                        final confirmed = await AppDialogs.confirm(
                          context,
                          title: 'settings_wird_reset_btn'.tr(),
                          message: 'settings_wird_reset_confirm'.tr(),
                          icon: Icons.restart_alt_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          confirmText: 'confirm',
                          cancelText: 'cancel',
                        );
                        if (confirmed == true) cubit.resetToFatihah();
                      },
                      child: Text(
                        'settings_wird_reset_btn'.tr(),
                        style: TextStyle(fontSize: 11.sp, color: appColors.accentGold),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Icon(icon, size: 16.sp, color: onTap != null ? appColors.accentGold : appColors.textMuted),
      ),
    );
  }
}
