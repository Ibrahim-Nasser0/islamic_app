import 'package:islamic_app/core/errors/failure.dart';


/// Categorized types of failures for visual presentation
enum FailureViewType {
  network,
  server,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  generic,
}

/// Resolves a [FailureViewType] from an optional [Failure], message, or status code
class FailureTypeResolver {
  const FailureTypeResolver._();

  static FailureViewType resolve({
    Failure? failure,
    String? message,
    int? statusCode,
  }) {
    // 1. Direct type checks from domain Failure
    if (failure is NetworkFailure) return FailureViewType.network;
    if (failure is TimeoutFailure) return FailureViewType.timeout;
    if (failure is UnauthorizedFailure) return FailureViewType.unauthorized;
    if (failure is ForbiddenFailure) return FailureViewType.forbidden;
    if (failure is NotFoundFailure) return FailureViewType.notFound;
    if (failure is ValidationFailure) return FailureViewType.validation;
    if (failure is ServerFailure) return FailureViewType.server;

    // 2. HTTP status code checks
    final code = statusCode ?? failure?.code;
    if (code != null) {
      if (code == 401) return FailureViewType.unauthorized;
      if (code == 403) return FailureViewType.forbidden;
      if (code == 404) return FailureViewType.notFound;
      if (code == 408 || code == 504) return FailureViewType.timeout;
      if (code == 400 || code == 409 || code == 422) {
        return FailureViewType.validation;
      }
      if (code >= 500 && code < 600) return FailureViewType.server;
    }

    // 3. String content heuristic fallback (Bilingual: Arabic & English)
    final text = (message ?? failure?.message ?? '').toLowerCase();

    // Network / Offline
    if (text.contains('network') ||
        text.contains('internet') ||
        text.contains('socket') ||
        text.contains('offline') ||
        text.contains('connection refused') ||
        text.contains('اتصال') ||
        text.contains('انترنت') ||
        text.contains('إنترنت') ||
        text.contains('الشبكة')) {
      return FailureViewType.network;
    }

    // Timeout
    if (text.contains('timeout') ||
        text.contains('timed out') ||
        text.contains('مهلة') ||
        text.contains('استغرق وقتا')) {
      return FailureViewType.timeout;
    }

    // Auth / Session
    if (text.contains('unauthorized') ||
        text.contains('401') ||
        text.contains('token') ||
        text.contains('session') ||
        text.contains('تسجيل الدخول') ||
        text.contains('جلسة') ||
        text.contains('صلاحية الحساب')) {
      return FailureViewType.unauthorized;
    }

    // Forbidden / Permissions
    if (text.contains('forbidden') ||
        text.contains('403') ||
        text.contains('permission') ||
        text.contains('غير مصرح') ||
        text.contains('لا تملك الصلاحية') ||
        text.contains('محظور')) {
      return FailureViewType.forbidden;
    }

    // Not Found
    if (text.contains('not found') ||
        text.contains('404') ||
        text.contains('غير موجود') ||
        text.contains('لم يتم العثور')) {
      return FailureViewType.notFound;
    }

    // Validation / Conflicts / Duplicate entries
    if (text.contains('validation') ||
        text.contains('422') ||
        text.contains('مأخوذ') ||
        text.contains('مستعمل') ||
        text.contains('مسجل') ||
        text.contains('مطلوب') ||
        text.contains('غير صحيح') ||
        text.contains('بيانات') ||
        text.contains('صيغة') ||
        text.contains('خطأ في المدخلات')) {
      return FailureViewType.validation;
    }

    // Server
    if (text.contains('server') ||
        text.contains('500') ||
        text.contains('internal error') ||
        text.contains('خادم') ||
        text.contains('السيرفر') ||
        text.contains('الخادم')) {
      return FailureViewType.server;
    }

    return FailureViewType.generic;
  }
}
