import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import '../base/sanctuary_dialog_badge.dart';
import 'failure_ui_config.dart';

/// Sanctuary geometric seal illustration for failure states.
class FailureBadgeIllustration extends StatelessWidget {
  final FailureUIConfig config;
  final bool isCompact;

  const FailureBadgeIllustration({
    super.key,
    required this.config,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SanctuaryDialogBadge(
      icon: config.icon,
      accentColor: config.accentColor,
      statusLabel: config.statusTagKey.tr(),
      subtleShake: true,
    );
  }
}
