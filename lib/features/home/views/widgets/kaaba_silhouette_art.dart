import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// Vector artwork for the Kaaba and Mecca minaret silhouette
class KaabaSilhouetteArt extends StatelessWidget {
  final Color goldColor;

  const KaabaSilhouetteArt({
    super.key,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.w,
      height: 120.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Kaaba Body
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0F12),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Stack(
              children: [
                // Golden Kiswah Band
                Positioned(
                  top: 14.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 5.h,
                    color: goldColor.withValues(alpha: 0.8),
                  ),
                ),
                // Kaaba Door
                Positioned(
                  bottom: 0,
                  right: 14.w,
                  child: Container(
                    width: 12.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: goldColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Side Minaret Accent
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 10.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1418),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
