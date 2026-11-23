import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/haptics.dart';

/// Collapsible technical details panel with copy-to-clipboard functionality
class FailureDetailsSection extends StatefulWidget {
  final String details;
  final int? code;

  const FailureDetailsSection({
    super.key,
    required this.details,
    this.code,
  });

  @override
  State<FailureDetailsSection> createState() => _FailureDetailsSectionState();
}

class _FailureDetailsSectionState extends State<FailureDetailsSection> {
  bool _isExpanded = false;

  void _copyToClipboard() {
    AppHaptics.light();
    final fullText = widget.code != null
        ? '[Code: ${widget.code}]\n${widget.details}'
        : widget.details;
    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('error_details_copied'.tr()),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle Button
        InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            AppHaptics.light();
            setState(() => _isExpanded = !_isExpanded);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                Gap(4.w),
                Text(
                  _isExpanded
                      ? 'hide_technical_details'.tr()
                      : 'view_technical_details'.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Collapsible Content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.all(12.w),
            constraints: BoxConstraints(maxWidth: 320.w, maxHeight: 120.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.15),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.code != null)
                        Text(
                          'HTTP ${widget.code}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      InkWell(
                        onTap: _copyToClipboard,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 13.sp,
                              color: theme.colorScheme.primary,
                            ),
                            Gap(4.w),
                            Text(
                              'copy_error_details'.tr(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(6.h),
                  SelectableText(
                    widget.details,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'monospace',
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
