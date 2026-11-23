import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// Search input bar for searching Surahs in Quran Tab
class QuranSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const QuranSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomTextField(
      hint: 'search_surah_hint'.tr(),
      prefixIcon: Icon(
        Icons.search_rounded,
        size: 20.sp,
        color: appColors.accentGold,
      ),
      onChanged: onChanged,
    );
  }
}
