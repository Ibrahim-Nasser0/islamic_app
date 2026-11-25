import 'package:islamic_app/core/errors/failure.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/widgets/dialogs/confirm/custom_confirm_dialog.dart';
import 'package:islamic_app/core/widgets/dialogs/error/custom_failure_dialog.dart';
import 'package:islamic_app/core/widgets/dialogs/error/failure_type.dart';
import 'package:islamic_app/core/widgets/dialogs/loading/custom_loading_dialog.dart';
import 'package:islamic_app/core/widgets/dialogs/success/custom_success_dialog.dart';
import 'package:material_ui/material_ui.dart';


/// Central Celestial Sanctuary Dialogs dispatcher for Zad Al-Muslim.
class AppDialogs {
  const AppDialogs._();

  static bool _isLoadingOpen = false;
  static BuildContext? _loadingContext;

  /// Apple-grade Frosted Glass Success Dialog with emerald glow and synchronized dismissals
  static Future<bool?> success(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
    VoidCallback? onPressed,
    bool popScreen = false,
    dynamic result,
    bool barrierDismissible = false,
  }) async {
    if (_isLoadingOpen) {
      hide(context);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!context.mounted) return null;
    }

    final confirmed = await CustomSuccessDialog.show<bool>(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      barrierDismissible: barrierDismissible,
    );

    if (confirmed == true) {
      (onConfirm ?? onPressed)?.call();
      if (popScreen) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (context.mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, result ?? true);
          } else if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop(result ?? true);
          } else {
            AppRouter.navigatorKey.currentState?.pop(result ?? true);
          }
        } else if (AppRouter.navigatorKey.currentState?.canPop() == true) {
          AppRouter.navigatorKey.currentState?.pop(result ?? true);
        }
      }
    }
    return confirmed;
  }

  /// Apple-grade Failure Dialog with automated type resolution and accurate message reporting
  static Future<T?> failure<T>(
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
    return CustomFailureDialog.show<T>(
      context,
      failure: failure,
      title: title,
      message: message,
      type: type,
      onRetry: onRetry,
      retryText: retryText,
      showDetails: showDetails,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Upgraded error dialog routing to Apple-grade Failure dialog with accurate title and message
  static void error(
    BuildContext context, {
    required String title,
    required String message,
    Failure? failure,
    VoidCallback? onRetry,
  }) {
    CustomFailureDialog.show(
      context,
      title: title,
      message: message,
      failure: failure,
      onRetry: onRetry,
    );
  }

  /// Celestial Sanctuary Frosted Loading Dialog with rotating mosque crest.
  static void loading(
    BuildContext context, {
    String? title,
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_isLoadingOpen) return;
    _isLoadingOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.50),
      builder: (dialogCtx) {
        _loadingContext = dialogCtx;
        return CustomLoadingDialog(
          title: title,
          message: message,
        );
      },
    ).then((_) {
      _isLoadingOpen = false;
      _loadingContext = null;
    });
  }

  /// Apple-grade Frosted Glass Confirmation Dialog with Amber rim glow
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'ok',
    String cancelText = 'cancel',
    IconData icon = Icons.warning_amber_rounded,
    Color iconColor = const Color(0xFFF59E0B),
    Color? confirmButtonColor,
  }) {
    return CustomConfirmDialog.show(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      iconColor: iconColor,
      confirmButtonColor: confirmButtonColor,
    );
  }

  /// Hides any currently active dialog
  static void hide(BuildContext context) {
    if (_isLoadingOpen) {
      _isLoadingOpen = false;
      if (_loadingContext != null && _loadingContext!.mounted) {
        Navigator.of(_loadingContext!).pop();
        _loadingContext = null;
        return;
      }
      if (context.mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
