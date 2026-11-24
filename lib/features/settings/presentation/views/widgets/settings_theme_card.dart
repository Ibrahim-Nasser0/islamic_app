import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/widgets/custom_switcher_tile.dart';
import 'package:material_ui/material_ui.dart';



class SettingsThemeCard extends StatelessWidget {
  const SettingsThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isNightTheme = themeMode == ThemeMode.dark;

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: appColors.cardBorder, width: 0.8),
            boxShadow: appColors.cardShadow,
          ),
          child: CustomSwitcherTile(
            title: isNightTheme ? 'dark_mode'.tr() : 'light_mode'.tr(),
            subtitle: isNightTheme ? 'theme_dark_desc'.tr() : 'theme_light_desc'.tr(),
            icon: isNightTheme ? Icons.nightlight_round : Icons.wb_sunny_rounded,
            iconColor: appColors.accentGold,
            value: isNightTheme,
            activeSwitchIcon: Icons.nightlight_round,
            inactiveSwitchIcon: Icons.wb_sunny_rounded,
            onChanged: (val) {
              context.read<ThemeCubit>().setThemeMode(
                    val ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
        );
      },
    );
  }
}
