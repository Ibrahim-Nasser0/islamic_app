import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../utils/extensions.dart';

/// Unified bottom sheet standard per AGENTS.md Rule 1.A
Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  FocusScope.of(context).unfocus();

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (modalContext) => CustomBottomSheetContainer(child: child),
  );
}

/// Standardized container for modal bottom sheets with drag handle and keyboard padding
class CustomBottomSheetContainer extends StatelessWidget {
  final Widget child;

  const CustomBottomSheetContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border(
            top: BorderSide(color: appColors.cardBorder, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(12.h),
            // Standard Drag Handle
            Center(
              child: Container(
                width: 38.w,
                height: 4.5.h,
                decoration: BoxDecoration(
                  color: appColors.cardBorder.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
            Gap(12.h),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
