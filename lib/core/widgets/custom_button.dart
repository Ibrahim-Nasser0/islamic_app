import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;
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
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: effectiveColor, width: 1.5),
                foregroundColor: effectiveColor,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
              ),
              child: _buildChild(context, effectiveColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
                elevation: 3,
                shadowColor: effectiveColor.withOpacity(0.35),
              ),
              child: _buildChild(context, effectiveColor),
            ),
    );
  }

  Widget _buildChild(BuildContext context, Color effectiveColor) {
    if (isLoading) {
      return SizedBox(
        width: 20.sp,
        height: 20.sp,
        child: CircularProgressIndicator(
          color: isOutlined ? effectiveColor : Colors.white,
          strokeWidth: 2.2,
        ),
      );
    }

    final effectiveFontSize = fontSize ?? (height < 45 ? 12.5.sp : 15.sp);
    final textColor = isOutlined ? effectiveColor : Colors.white;

    final textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: effectiveFontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: (effectiveFontSize + 4).sp, color: textColor),
          SizedBox(width: 6.w),
          Flexible(child: textWidget),
        ],
      );
    }
    return Center(child: textWidget);
  }
}
