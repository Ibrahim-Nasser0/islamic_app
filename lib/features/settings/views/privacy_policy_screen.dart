import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/native/permission_readiness_cubit.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/permissions_checklist_sheet.dart';
import '../presentation/views/widgets/privacy_actions_card.dart';
import '../presentation/views/widgets/privacy_hero_card.dart';
import '../presentation/views/widgets/privacy_section_card.dart';

/// Full-screen Privacy Policy & Permissions transparency view.
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  PermissionReadinessCubit? _permCubit;

  @override
  void initState() {
    super.initState();
    if (di.sl.isRegistered<PermissionReadinessCubit>()) {
      _permCubit = di.sl<PermissionReadinessCubit>();
    }
  }

  @override
  void dispose() {
    _permCubit?.close();
    super.dispose();
  }

  void _openPermissionsSheet() {
    final cubit = _permCubit;
    if (cubit == null) return;
    PermissionsChecklistSheet.show(context, cubit);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'privacy_policy_title'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PrivacyHeroCard(),
            Gap(14.h),
            PrivacySectionCard(
              icon: Icons.storage_outlined,
              title: 'privacy_sec1_title'.tr(),
              body: 'privacy_sec1_body'.tr(),
            ),
            Gap(12.h),
            PrivacySectionCard(
              icon: Icons.location_on_outlined,
              title: 'privacy_sec2_title'.tr(),
              body: 'privacy_sec2_body'.tr(),
            ),
            Gap(12.h),
            PrivacySectionCard(
              icon: Icons.notifications_active_outlined,
              title: 'privacy_sec3_title'.tr(),
              body: 'privacy_sec3_body'.tr(),
            ),
            Gap(12.h),
            PrivacySectionCard(
              icon: Icons.public_outlined,
              title: 'privacy_sec4_title'.tr(),
              body: 'privacy_sec4_body'.tr(),
            ),
            Gap(12.h),
            PrivacySectionCard(
              icon: Icons.gpp_good_outlined,
              title: 'privacy_sec5_title'.tr(),
              body: 'privacy_sec5_body'.tr(),
            ),
            Gap(14.h),
            PrivacyActionsCard(
              onReviewPermissions:
                  _permCubit != null ? _openPermissionsSheet : null,
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}
