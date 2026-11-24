import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdhanVisualizerWave extends StatefulWidget {
  final bool isPlaying;

  const AdhanVisualizerWave({super.key, required this.isPlaying});

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
      duration: const Duration(milliseconds: 2800),
    );
    if (widget.isPlaying) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AdhanVisualizerWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _controller.repeat() : _controller.stop();
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
          width: 240.w,
          height: 240.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildPulseRing((_controller.value + 0.0) % 1.0),
              _buildPulseRing((_controller.value + 0.33) % 1.0),
              _buildPulseRing((_controller.value + 0.66) % 1.0),
              _buildOctagramStar(),
              _buildCenterMedallion(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPulseRing(double progress) {
    if (!widget.isPlaying) return const SizedBox.shrink();
    final size = 120.w + (progress * 115.w);
    final opacity = ((1.0 - progress) * 0.32).clamp(0.0, 1.0);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE0B866).withValues(alpha: opacity),
          width: 1.2.w,
        ),
      ),
    );
  }

  Widget _buildOctagramStar() {
    final scale = widget.isPlaying
        ? 1.0 + (math.sin(_controller.value * 2 * math.pi) * 0.035)
        : 1.0;

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 130.w,
        height: 130.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildStarSquare(0),
            _buildStarSquare(math.pi / 4),
          ],
        ),
      ),
    );
  }

  Widget _buildStarSquare(double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 108.w,
        height: 108.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFE0B866).withValues(alpha: 0.38),
            width: 1.4.w,
          ),
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
    );
  }

  Widget _buildCenterMedallion(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.16),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE0B866).withValues(alpha: 0.55),
          width: 1.6.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 20.r,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFFE0B866).withValues(alpha: 0.12),
            blurRadius: 16.r,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isPlaying
                  ? Icons.graphic_eq_rounded
                  : Icons.mosque_rounded,
              size: 36.sp,
              color: const Color(0xFFFFD54F),
            ),
            SizedBox(height: 4.h),
            _buildLiveStatusDot(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusDot() {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isPlaying
            ? const Color(0xFF10B981)
            : const Color(0xFF9E9E9E),
        boxShadow: widget.isPlaying
            ? [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.8),
                  blurRadius: 6.r,
                ),
              ]
            : null,
      ),
    );
  }
}
