import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/wird_item.dart';
import 'add_custom_dhikr_form.dart';
import 'wird_item_row.dart';
import 'wird_presets_bar.dart';

/// Modal bottom sheet content for customizing Daily Wird items and counts
class WirdCustomizationSheet extends StatefulWidget {
  final List<WirdItem> items;
  final Function(String id, bool enabled) onToggle;
  final Function(String id, int target) onTargetChanged;
  final Function(int target) onApplyAllTargets;
  final Function(String text, int target) onAddCustom;
  final Function(String id) onDeleteCustom;

  const WirdCustomizationSheet({
    super.key,
    required this.items,
    required this.onToggle,
    required this.onTargetChanged,
    required this.onApplyAllTargets,
    required this.onAddCustom,
    required this.onDeleteCustom,
  });

  @override
  State<WirdCustomizationSheet> createState() => _WirdCustomizationSheetState();
}

class _WirdCustomizationSheetState extends State<WirdCustomizationSheet> {
  bool _showAddForm = false;

  int get _enabledCount => widget.items.where((i) => i.isEnabled).length;

  Future<void> _confirmDelete(String id, String title) async {
    AppHaptics.heavy();
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'delete'.tr(),
      message: 'هل تريد حقاً حذف "$title" من الورد؟',
      confirmText: 'delete'.tr(),
      cancelText: 'cancel'.tr(),
    );
    if (confirmed == true) {
      widget.onDeleteCustom(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sheet Header with count badge and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'customize_wird'.tr(),
                      style: AppTypography.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'active_items_count'.tr(
                          namedArgs: {'count': '$_enabledCount'},
                        ),
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.bold,
                          color: appColors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            Gap(14.h),

            // Hero Unified Presets Bar (Set 100 to all, 70, 33)
            WirdPresetsBar(onApplyTargetToAll: widget.onApplyAllTargets),
            Gap(14.h),

            // Dhikr Items List
            ...widget.items.map((item) {
              final isCustom = item.id.startsWith('custom_');
              return WirdItemRow(
                item: item,
                onToggle: (val) => widget.onToggle(item.id, val),
                onTargetChanged: (t) => widget.onTargetChanged(item.id, t),
                onDelete: isCustom
                    ? () => _confirmDelete(item.id, item.arabicText)
                    : null,
              );
            }),
            Gap(6.h),

            // Add Custom Dhikr Expandable Section
            if (!_showAddForm)
              InkWell(
                onTap: () {
                  AppHaptics.light();
                  setState(() => _showAddForm = true);
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: appColors.badgeBackground,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 18.sp,
                        color: appColors.accentGold,
                      ),
                      Gap(6.w),
                      Text(
                        'add_new_dhikr'.tr(),
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: appColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              AddCustomDhikrForm(
                onAdd: (text, target) {
                  widget.onAddCustom(text, target);
                  setState(() => _showAddForm = false);
                },
                onCancel: () => setState(() => _showAddForm = false),
              ),
          ],
        ),
      ),
    );
  }
}
