import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import '../../../utils/extensions.dart';
import '../base/sanctuary_dialog_badge.dart';

/// Sanctuary emerald seal illustration for success states.
class SuccessBadgeIllustration extends StatelessWidget {
  final Color? accentColor;
  final List<Color>? gradientColors;

  const SuccessBadgeIllustration({
    super.key,
    this.accentColor,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedAccent = accentColor ?? context.appColors.statusSuccess;
    return SanctuaryDialogBadge(
      icon: Icons.check_rounded,
      accentColor: resolvedAccent,
      statusLabel: 'status_success'.tr(),
      useEmeraldBevel: true,
    );
  }
}
