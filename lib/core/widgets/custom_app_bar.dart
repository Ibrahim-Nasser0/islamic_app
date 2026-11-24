import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../routes/app_router.dart';
import '../routes/routes.dart';
import '../theme/typography.dart';
import '../utils/extensions.dart';
import '../utils/haptics.dart';
import 'islamic/gold_hairline_divider.dart';
import 'islamic/octagonal_icon_frame.dart';

/// Celestial Sanctuary AppBar anchored by an octagonal crest & gold divider.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showSettingsButton;
  final List<Widget>? extraActions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showSettingsButton = true,
    this.extraActions,
  });

  @override
  Size get preferredSize {
    // Flexible height that accounts for text scaling
    final base = 64.h;
    return Size.fromHeight(base.clamp(56.0, 80.0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: appColors.navCapsuleBg.withValues(alpha: 0.94),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        if (showBackButton)
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            iconSize: 20.sp,
                            color: theme.colorScheme.onSurface,
                            onPressed: () {
                              AppHaptics.light();
                              Navigator.pop(context);
                            },
                          )
                        else
                          OctagonalIconFrame(
                            size: 38,
                            active: true,
                            child: Icon(
                              FlutterIslamicIcons.solidMosque,
                              size: 18.sp,
                              color: appColors.accentGold,
                            ),
                          ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            title ?? 'app_name'.tr(),
                            style: AppTypography.quranAyah.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              height: 1.25,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...?extraActions,
                        if (showSettingsButton)
                          IconButton(
                            icon: Icon(Icons.settings_outlined, color: appColors.accentGold),
                            iconSize: 22.sp,
                            tooltip: 'settings'.tr(),
                            onPressed: () {
                              AppHaptics.light();
                              AppRouter.navigateTo(context, Routes.settings);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const GoldHairlineDivider(jewelSize: 11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
