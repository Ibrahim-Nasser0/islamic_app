import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/features/mosques/domain/entities/mosque.dart';
import 'package:material_ui/material_ui.dart';


class MosqueMarkerWidget extends StatelessWidget {
  final Mosque mosque;
  final bool isSelected;
  final VoidCallback onTap;

  const MosqueMarkerWidget({
    super.key,
    required this.mosque,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final primaryColor = theme.colorScheme.primary;
    final goldColor = appColors.accentGold;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.18 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isSelected ? 7.r : 5.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? goldColor : appColors.cardBorder,
                  width: isSelected ? 1.8 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isSelected ? primaryColor : Colors.black)
                        .withValues(alpha: isSelected ? 0.35 : 0.15),
                    blurRadius: isSelected ? 10 : 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                FlutterIslamicIcons.locationMosque,
                size: isSelected ? 18.sp : 14.sp,
                color: isSelected ? Colors.white : primaryColor,
              ),
            ),
            CustomPaint(
              size: Size(8.w, 5.h),
              painter: _MarkerArrowPainter(
                color: isSelected ? primaryColor : theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkerArrowPainter extends CustomPainter {
  final Color color;

  const _MarkerArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}
