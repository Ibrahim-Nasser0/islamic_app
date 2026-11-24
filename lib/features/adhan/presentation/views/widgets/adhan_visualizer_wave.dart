import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdhanVisualizerWave extends StatefulWidget {
  final bool isPlaying;

  const AdhanVisualizerWave({
    super.key,
    required this.isPlaying,
  });

  @override
  State<AdhanVisualizerWave> createState() => _AdhanVisualizerWaveState();
}

class _AdhanVisualizerWaveState extends State<AdhanVisualizerWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AdhanVisualizerWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 220.w,
          height: 220.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildPulseRing(progress: (_controller.value + 0.0) % 1.0),
              _buildPulseRing(progress: (_controller.value + 0.33) % 1.0),
              _buildPulseRing(progress: (_controller.value + 0.66) % 1.0),
              _buildCenterMedallion(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPulseRing({required double progress}) {
    if (!widget.isPlaying) return const SizedBox.shrink();

    final size = 110.w + (progress * 110.w);
    final opacity = ((1.0 - progress) * 0.28).clamp(0.0, 1.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 1.2.w,
        ),
      ),
    );
  }

  Widget _buildCenterMedallion(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 110.w,
      height: 110.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 18.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: AnimatedScale(
          scale: widget.isPlaying ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            widget.isPlaying
                ? Icons.volume_up_rounded
                : Icons.notifications_active_rounded,
            size: 46.sp,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
