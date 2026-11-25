/// Tactile/audio feedback preference during Tasbeeh counting.
enum TasbeehFeedbackMode {
  haptic,
  soundAndHaptic,
  silent;

  TasbeehFeedbackMode next() {
    switch (this) {
      case TasbeehFeedbackMode.haptic:
        return TasbeehFeedbackMode.soundAndHaptic;
      case TasbeehFeedbackMode.soundAndHaptic:
        return TasbeehFeedbackMode.silent;
      case TasbeehFeedbackMode.silent:
        return TasbeehFeedbackMode.haptic;
    }
  }

  String get labelKey {
    switch (this) {
      case TasbeehFeedbackMode.haptic:
        return 'tasbeeh_feedback_haptic';
      case TasbeehFeedbackMode.soundAndHaptic:
        return 'tasbeeh_feedback_sound';
      case TasbeehFeedbackMode.silent:
        return 'tasbeeh_feedback_silent';
    }
  }
}
