import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/animations/button_animation.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// Form component to create a custom Dhikr with selectable target count chips
class AddCustomDhikrForm extends StatefulWidget {
  final Function(String text, int target) onAdd;
  final VoidCallback onCancel;

  const AddCustomDhikrForm({
    super.key,
    required this.onAdd,
    required this.onCancel,
  });

  @override
  State<AddCustomDhikrForm> createState() => _AddCustomDhikrFormState();
}

class _AddCustomDhikrFormState extends State<AddCustomDhikrForm> {
  final TextEditingController _dhikrController = TextEditingController();
  int _selectedTarget = 100;
  static const List<int> _targetOptions = [33, 70, 100, 300, 500, 1000];

  @override
  void dispose() {
    _dhikrController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _dhikrController.text.trim();
    if (text.isNotEmpty) {
      AppHaptics.medium();
      widget.onAdd(text, _selectedTarget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'add_new_dhikr'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: widget.onCancel,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Gap(10.h),
          CustomTextField(
            controller: _dhikrController,
            hint: 'enter_dhikr_hint'.tr(),
            label: 'dhikr_text'.tr(),
          ),
          Gap(10.h),
          Text(
            'target_number'.tr(),
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: appColors.textMuted,
            ),
          ),
          Gap(6.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: _targetOptions.map((target) {
              final isSelected = _selectedTarget == target;
              return InkWell(
                onTap: () {
                  AppHaptics.selection();
                  setState(() => _selectedTarget = target);
                },
                borderRadius: BorderRadius.circular(10.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? appColors.accentGold.withValues(alpha: 0.2)
                        : appColors.badgeBackground,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isSelected ? appColors.accentGold : appColors.cardBorder,
                      width: isSelected ? 1.2 : 0.8,
                    ),
                  ),
                  child: Text(
                    '$target',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? appColors.accentGold : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Gap(12.h),
          CustomButton(
            text: 'save_wird'.tr(),
            onPressed: _submit,
          ).buttonAnimation(),
        ],
      ),
    );
  }
}
