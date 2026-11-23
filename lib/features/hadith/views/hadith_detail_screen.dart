import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/haptics.dart';
import '../domain/entities/hadith_item.dart';
import 'widgets/hadith_benefit_card.dart';
import 'widgets/hadith_content_card.dart';

class HadithDetailScreen extends StatelessWidget {
  final HadithItem hadith;

  const HadithDetailScreen({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20.sp,
          ),
          onPressed: () {
            AppHaptics.light();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'الحديث ${hadith.number}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.copy_rounded,
              color: appColors.accentGold,
              size: 20.sp,
            ),
            tooltip: 'نسخ الحديث',
            onPressed: () => _copyHadith(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleCard(context),
            Gap(16.h),
            HadithContentCard(hadith: hadith),
            Gap(16.h),
            _buildNarratorCard(context),
            if (hadith.benefit != null) ...[
              Gap(16.h),
              HadithBenefitCard(benefit: hadith.benefit!),
            ],
          ],
        ),
      ),
    );
  }

  void _copyHadith(BuildContext context) {
    AppHaptics.light();
    final fullText =
        '«${hadith.arabicText}»\n\n[ ${hadith.narrator} - ${hadith.reference} ]';
    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الحديث الشريف بنجاح'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: appColors.badgeBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            FlutterIslamicIcons.mohammad,
            color: appColors.accentGold,
            size: 24.sp,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hadith.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (hadith.chapter != null) ...[
                  Gap(4.h),
                  Text(
                    hadith.chapter!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: appColors.accentGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarratorCard(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: appColors.cardBorder, width: 0.6),
      ),
      child: Row(
        children: [
          Icon(
            Icons.record_voice_over_rounded,
            color: appColors.accentGold,
            size: 18.sp,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hadith.narrator,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(2.h),
                Text(
                  hadith.reference,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: appColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
