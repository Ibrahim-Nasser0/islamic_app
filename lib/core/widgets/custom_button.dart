import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// Shared primary/secondary button supporting default Material and Celestial Sanctuary styles.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;
  final Color? textColor;
  final Color? iconColor;
  final IconData? icon;
  final bool iconAfterText;
  final double? width;
  final double height;
  final double borderRadius;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.textColor,
    this.iconColor,
    this.icon,
    this.iconAfterText = false,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final radius = BorderRadius.circular(borderRadius.r);

    if (gradient != null || (borderColor != null && !isOutlined)) {
      final fg = textColor ?? Colors.white;
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? effectiveColor : null,
              borderRadius: radius,
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
            ),
            child: InkWell(
              onTap: (isLoading || onPressed == null) ? null : onPressed,
              borderRadius: radius,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _buildChild(fg, fg),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor ?? effectiveColor, width: 1.5),
                foregroundColor: textColor ?? effectiveColor,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                shape: RoundedRectangleBorder(borderRadius: radius),
              ),
              child: _buildChild(effectiveColor, textColor ?? effectiveColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveColor,
                foregroundColor: textColor ?? Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                shape: RoundedRectangleBorder(borderRadius: radius),
                elevation: 3,
                shadowColor: effectiveColor.withValues(alpha: 0.35),
              ),
              child: _buildChild(effectiveColor, textColor ?? Colors.white),
            ),
    );
  }

  Widget _buildChild(Color spinnerColor, Color fg) {
    if (isLoading) {
      return SizedBox(
        width: 20.sp,
        height: 20.sp,
        child: CircularProgressIndicator(color: spinnerColor, strokeWidth: 2.2),
      );
    }
    final effSize = fontSize ?? (height < 45 ? 12.5.sp : 15.sp);
    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: effSize, fontWeight: FontWeight.w600, color: fg),
    );
    if (icon == null) return Center(child: label);

    final iconWidget = Icon(icon, size: (effSize + 3.5).sp, color: iconColor ?? fg);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconAfterText
          ? [Flexible(child: label), SizedBox(width: 5.w), iconWidget]
          : [iconWidget, SizedBox(width: 6.w), Flexible(child: label)],
    );
  }
}
