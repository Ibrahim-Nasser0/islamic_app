import 'package:material_ui/material_ui.dart';

/// Explicit one-shot staggered entrance animation for Home sections.
/// Respects system reduced-motion preferences and disposes tickers cleanly.
class HomeStaggeredEntry extends StatefulWidget {
  final int index;
  final Widget child;

  const HomeStaggeredEntry({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<HomeStaggeredEntry> createState() => _HomeStaggeredEntryState();
}

class _HomeStaggeredEntryState extends State<HomeStaggeredEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 540),
    );
    final start = (widget.index * 0.10).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.45, 1.0);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Subtle slow breathing motion for focal medallions.
class SanctuaryBreathingPulse extends StatefulWidget {
  final Widget child;
  const SanctuaryBreathingPulse({super.key, required this.child});

  @override
  State<SanctuaryBreathingPulse> createState() =>
      _SanctuaryBreathingPulseState();
}

class _SanctuaryBreathingPulseState extends State<SanctuaryBreathingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

/// Tactile press-scale wrapper providing physical depression on tap.
class TactilePressScale extends StatefulWidget {
  final Widget Function(BuildContext context, ValueChanged<bool> onHighlight)
      builder;

  const TactilePressScale({super.key, required this.builder});

  @override
  State<TactilePressScale> createState() => _TactilePressScaleState();
}

class _TactilePressScaleState extends State<TactilePressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOutCubic,
      child: widget.builder(
        context,
        (v) {
          if (v != _pressed) setState(() => _pressed = v);
        },
      ),
    );
  }
}
