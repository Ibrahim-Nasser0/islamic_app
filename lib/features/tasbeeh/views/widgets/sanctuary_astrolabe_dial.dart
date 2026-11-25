import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';
import 'tasbeeh_astrolabe_painter.dart';
import 'tasbeeh_dial_content.dart';

/// Unified tactile Astrolabe Medallion Dial shared across Free and Wird modes.
class SanctuaryAstrolabeDial extends StatefulWidget {
  final int count;
  final String cycleBadge;
  final String targetLabel;
  final double progress;
  final bool isCompleted;
  final bool isMilestoneBeat;
  final double diameter;
  final VoidCallback onTap;

  const SanctuaryAstrolabeDial({
    super.key,
    required this.count,
    required this.cycleBadge,
    required this.targetLabel,
    required this.progress,
    required this.onTap,
    this.isCompleted = false,
    this.isMilestoneBeat = false,
    this.diameter = 246,
  });

  @override
  State<SanctuaryAstrolabeDial> createState() => _SanctuaryAstrolabeDialState();
}

class _SanctuaryAstrolabeDialState extends State<SanctuaryAstrolabeDial>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late final AnimationController _rippleCtrl;

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
  }

  @override
  void didUpdateWidget(covariant SanctuaryAstrolabeDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count > oldWidget.count) {
      _rippleCtrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final d = widget.diameter;
    final innerD = d * 0.80;
    final activeHero = widget.isCompleted || widget.isMilestoneBeat;
    final trackColor =
        widget.isCompleted ? appColors.statusSuccess : appColors.accentGold;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _rippleCtrl.forward(from: 0.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 95),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: d,
          height: d,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rippleCtrl,
                builder: (_, _) {
                  final t = _rippleCtrl.value;
                  if (t == 0 || t == 1) return const SizedBox.shrink();
                  final rippleSize = innerD + (d - innerD) * t;
                  return Container(
                    width: rippleSize,
                    height: rippleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: trackColor.withValues(alpha: (1 - t) * 0.45),
                        width: 2.0,
                      ),
                    ),
                  );
                },
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: widget.progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                builder: (_, animatedProgress, _) => Positioned.fill(
                  child: CustomPaint(
                    painter: TasbeehAstrolabePainter(
                      progress: animatedProgress,
                      activeColor: trackColor,
                      inactiveColor: appColors.cardBorder,
                      beadCoreColor: AppColors.accentLight,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: innerD,
                height: innerD,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: activeHero
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColors.emeraldBevelTop,
                            appColors.emeraldBevelBottom,
                          ],
                        )
                      : null,
                  color: activeHero ? null : theme.colorScheme.surface,
                  border: Border.all(
                    color: trackColor.withValues(alpha: activeHero ? 0.72 : 0.38),
                    width: activeHero ? 1.4 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: trackColor.withValues(alpha: activeHero ? 0.20 : 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TasbeehDialCenterContent(
                  count: widget.count,
                  cycleBadge: widget.cycleBadge,
                  targetLabel: widget.targetLabel,
                  diameter: d,
                  activeHero: activeHero,
                  isCompleted: widget.isCompleted,
                  trackColor: trackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
