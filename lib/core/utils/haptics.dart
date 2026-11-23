import 'package:flutter/services.dart';

/// Haptic feedback helper for micro-interactions
class AppHaptics {
  AppHaptics._();

  /// Light haptic feedback for subtle actions like tab selection, chips, or toggles
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for standard button taps and card selections
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for destructive actions or important saves
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Selection click feedback for pickers, sliders, and segmented controls
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
