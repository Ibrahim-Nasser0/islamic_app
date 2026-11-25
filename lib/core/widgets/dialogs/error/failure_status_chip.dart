import 'package:material_ui/material_ui.dart';
import '../base/sanctuary_dialog_badge.dart';

/// Sanctuary status chip for Failure states.
class FailureStatusChip extends StatelessWidget {
  final String label;
  final Color accentColor;
  final bool isCompact;

  const FailureStatusChip({
    super.key,
    required this.label,
    required this.accentColor,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SanctuaryDialogChip(label: label, accentColor: accentColor);
  }
}
