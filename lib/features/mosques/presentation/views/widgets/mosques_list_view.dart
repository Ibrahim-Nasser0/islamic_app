import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/widgets/custom_button.dart';
import 'package:islamic_app/features/mosques/domain/entities/mosque.dart';
import 'package:material_ui/material_ui.dart';

import 'mosque_list_card.dart';

class MosquesListView extends StatelessWidget {
  final List<Mosque> mosques;
  final Mosque? selectedMosque;
  final ValueChanged<Mosque> onMosqueSelected;
  final ValueChanged<Mosque> onDirections;
  final Future<void> Function() onRefresh;
  final VoidCallback onExpandRadius;

  const MosquesListView({
    super.key,
    required this.mosques,
    required this.selectedMosque,
    required this.onMosqueSelected,
    required this.onDirections,
    required this.onRefresh,
    required this.onExpandRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    if (mosques.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  FlutterIslamicIcons.locationMosque,
                  size: 34.sp,
                  color: theme.colorScheme.primary,
                ),
              ),
              Gap(16.h),
              Text(
                'no_mosques_found'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Gap(8.h),
              Text(
                'no_mosques_found_desc'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.textMuted,
                  fontSize: 13.sp,
                ),
              ),
              Gap(20.h),
              CustomButton(
                text: 'radius_5km'.tr(),
                width: 140.w,
                height: 44.h,
                borderRadius: 12,
                fontSize: 13.sp,
                onPressed: onExpandRadius,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: mosques.length,
        itemBuilder: (context, index) {
          final mosque = mosques[index];
          return MosqueListCard(
            mosque: mosque,
            isNearest: index == 0,
            onTap: () => onMosqueSelected(mosque),
            onDirections: () => onDirections(mosque),
          );
        },
      ),
    );
  }
}
