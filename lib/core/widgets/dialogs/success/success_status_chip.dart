import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import '../../../utils/extensions.dart';
import '../base/sanctuary_dialog_badge.dart';

/// Emerald sanctuary status chip for the Success Dialog.
class SuccessStatusChip extends StatelessWidget {
  final Color? accentColor;

  const SuccessStatusChip({super.key, this.accentColor});

  @override
  Widget build(BuildContext context) {
    return SanctuaryDialogChip(
      label: 'status_success'.tr(),
      accentColor: accentColor ?? context.appColors.statusSuccess,
    );
  }
}
