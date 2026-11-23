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

/// Central luxury AppBar for the Islamic Application
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
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.92),
            border: Border(
              bottom: BorderSide(
                color: appColors.cardBorder,
                width: 0.8,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
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
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appColors.accentGold.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Icon(
                        FlutterIslamicIcons.solidMosque,
                        size: 19.sp,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title ?? 'app_name'.tr(),
                      style: AppTypography.h3.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...?extraActions,
                  if (showSettingsButton)
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      iconSize: 22.sp,
                      color: theme.colorScheme.onSurface,
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
        ),
      ),
    );
  }
}
