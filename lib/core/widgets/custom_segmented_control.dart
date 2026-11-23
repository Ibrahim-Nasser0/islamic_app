import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../utils/extensions.dart';
import '../utils/haptics.dart';

/// Unified segmented tab selector per AGENTS.md Rule 1.B
class CustomSegmentedControl extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;
  final double? height;

  const CustomSegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onValueChanged,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      height: height ?? 46.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / options.length;

          return Stack(
            children: [
              // Sliding Highlight Pill
              AnimatedAlign(
                alignment: AlignmentDirectional(
                  -1.0 + (2.0 / (options.length - 1)) * selectedIndex,
                  0.0,
                ),
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: itemWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Labels Row
              Row(
                children: List.generate(options.length, (index) {
                  final isSelected = index == selectedIndex;
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        if (index != selectedIndex) {
                          AppHaptics.selection();
                          onValueChanged(index);
                        }
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Center(
                        child: Text(
                          options[index],
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? appColors.accentGold
                                : appColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
