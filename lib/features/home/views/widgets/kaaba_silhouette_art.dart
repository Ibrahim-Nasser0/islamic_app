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
    final screenW = MediaQuery.sizeOf(context).width;
    final artWidth = (screenW * 0.37).clamp(95.0, 160.0);
    final artHeight = artWidth * (120 / 140);

    return SizedBox(
      width: artWidth,
      height: artHeight,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 140,
          height: 120,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0F12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 14,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 5,
                        color: goldColor.withValues(alpha: 0.8),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 14,
                      child: Container(
                        width: 12,
                        height: 28,
                        decoration: BoxDecoration(
                          color: goldColor.withValues(alpha: 0.7),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1418),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
