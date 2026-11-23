import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/errors/failure.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import '../base/dialog_frosted_vessel.dart';
import 'failure_badge_illustration.dart';
import 'failure_details_section.dart';
import 'failure_dialog_actions.dart';
import 'failure_type.dart';
import 'failure_ui_config.dart';

/// Apple-grade frosted glass Failure Dialog with cohesive branding and accurate error reporting
class CustomFailureDialog extends StatelessWidget {
  final Failure? failure;
  final String? title;
  final String? message;
  final FailureViewType? type;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool showDetails;

  const CustomFailureDialog({
    super.key,
    this.failure,
    this.title,
    this.message,
    this.type,
    this.onRetry,
    this.retryText,
    this.showDetails = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    Failure? failure,
    String? title,
    String? message,
    FailureViewType? type,
    VoidCallback? onRetry,
    String? retryText,
    bool showDetails = true,
    bool barrierDismissible = true,
  }) {
    AppHaptics.medium();
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => CustomFailureDialog(
        failure: failure,
        title: title,
        message: message,
        type: type,
        onRetry: onRetry,
        retryText: retryText,
        showDetails: showDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = type ??
        FailureTypeResolver.resolve(failure: failure, message: message);
    final config = FailureUIConfig.fromType(resolved, theme);

    // 1. Title Resolution: Priority to caller's title, then fallback to config title
    final resolvedTitle = (title != null && title!.trim().isNotEmpty)
        ? title!
        : config.titleKey.tr();

    // 2. Primary Message Resolution: Explicit message takes highest priority
    final explicitMessage = message ?? failure?.message;
    final defaultDesc = config.descKey.tr();
    final primaryDescription =
        (explicitMessage != null && explicitMessage.trim().isNotEmpty)
            ? explicitMessage
            : defaultDesc;

    // 3. Technical details: Only shown when there are extra technical specs (HTTP code or raw failure code)
    final hasTechnicalDetails =
        showDetails && failure?.code != null && failure!.code != 0;

    return DialogFrostedVessel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FailureBadgeIllustration(config: config, isCompact: true),
          Gap(14.h),
          Text(
            resolvedTitle,
            textAlign: TextAlign.center,
            style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          Gap(6.h),
          Text(
            primaryDescription,
            textAlign: TextAlign.center,
            style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 12.5.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.65),
              height: 1.4,
            ),
          ),
          if (hasTechnicalDetails) ...[
            Gap(8.h),
            FailureDetailsSection(
              details: primaryDescription,
              code: failure?.code,
            ),
          ],
          Gap(20.h),
          FailureDialogActions(
            config: config,
            onRetry: onRetry,
            retryText: retryText,
          ),
        ],
      ),
    );
  }
}
