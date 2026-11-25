import 'package:material_ui/material_ui.dart';
import '../base/sanctuary_dialog_badge.dart';

/// Sanctuary geometric seal illustration for confirmation dialogs.
class ConfirmBadgeIllustration extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const ConfirmBadgeIllustration({
    super.key,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = icon == Icons.warning_amber_rounded ||
        icon == Icons.visibility_off_rounded ||
        icon == Icons.error_outline_rounded;

    return SanctuaryDialogBadge(
      icon: icon,
      accentColor: iconColor,
      subtleShake: isWarning,
    );
  }
}
