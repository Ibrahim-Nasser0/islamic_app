import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:material_ui/material_ui.dart';


class MosquesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int mosquesCount;
  final bool isMapView;
  final VoidCallback onToggleView;
  final VoidCallback onRefresh;

  const MosquesAppBar({
    super.key,
    required this.mosquesCount,
    required this.isMapView,
    required this.onToggleView,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'nearby_mosques'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(
            mosquesCount > 0
                ? 'mosques_count_found'
                    .tr(namedArgs: {'count': mosquesCount.toString()})
                : 'nearby_mosques_subtitle'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.textMuted,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            AppHaptics.selection();
            onToggleView();
          },
          icon: Icon(
            isMapView ? Icons.view_list_rounded : Icons.map_outlined,
            color: theme.colorScheme.primary,
            size: 22.sp,
          ),
          tooltip: isMapView ? 'view_list'.tr() : 'view_map'.tr(),
        ),
        IconButton(
          onPressed: () {
            AppHaptics.light();
            onRefresh();
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: theme.colorScheme.onSurface,
            size: 22.sp,
          ),
          tooltip: 'retry'.tr(),
        ),
      ],
    );
  }
}
