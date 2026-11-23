import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AppAnimations on Widget {
  Widget fadeAnimation() {
    return animate().fade(delay: 100.ms, duration: 700.ms);
  }
}
