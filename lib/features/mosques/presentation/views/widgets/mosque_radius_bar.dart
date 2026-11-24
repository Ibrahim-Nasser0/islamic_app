import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:material_ui/material_ui.dart';


class MosqueRadiusBar extends StatelessWidget {
  final double selectedRadius;
  final ValueChanged<double> onRadiusChanged;

  const MosqueRadiusBar({
    super.key,
    required this.selectedRadius,
    required this.onRadiusChanged,
  });

  static const List<Map<String, dynamic>> _radiusOptions = [
    {'labelKey': 'radius_500m', 'meters': 500.0},
    {'labelKey': 'radius_1km', 'meters': 1000.0},
    {'labelKey': 'radius_3km', 'meters': 3000.0},
    {'labelKey': 'radius_5km', 'meters': 5000.0},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _radiusOptions.map((opt) {
          final meters = opt['meters'] as double;
          final labelKey = opt['labelKey'] as String;
          final isSelected = (selectedRadius - meters).abs() < 1.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (!isSelected) {
                    AppHaptics.selection();
                    onRadiusChanged(meters);
                  }
                },
                borderRadius: BorderRadius.circular(10.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.12)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : appColors.cardBorder,
                      width: isSelected ? 1.2 : 0.8,
                    ),
                  ),
                  child: Text(
                    labelKey.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
