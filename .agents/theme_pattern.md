# Theme Usage Pattern — Mot7km App

## الفلسفة الأساسية

> **اعتمد على نظام الـ Theme بالكامل، ولا تقرر بنفسك اللون حسب الـ brightness.**

الـ Flutter Theme System صُمِّم بحيث إنه هو اللي يتحكم في الألوان تلقائياً عند التحويل بين Light/Dark.
لما بتعمل check يدوي على `isDark`، بتكسر هذا المبدأ وبتعمل كود أصعب في الصيانة.

---

## الطريقة الصح (Auth Pattern)

### 1. الوصول للـ Theme مباشرة من Theme.of(context)

```dart
// صح
style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  color: Theme.of(context).colorScheme.onSurface,
),

// أو لو محتاج تستخدمه أكتر من مرة في نفس الـ build method
final theme = Theme.of(context);
// ثم استخدم theme.colorScheme.X و theme.textTheme.X
```

### 2. استخدام colorScheme للألوان الديناميكية

| بدل | استخدم |
|-----|--------|
| isDark ? Colors.white : Colors.black87 | theme.colorScheme.onSurface |
| isDark ? Colors.white70 : Colors.black54 | theme.colorScheme.onSurface.withOpacity(0.6) |
| isDark ? Colors.white38 : Colors.black38 | theme.colorScheme.onSurfaceVariant |
| isDark ? theme.colorScheme.surface : Colors.white | theme.colorScheme.surface |
| isDark ? Colors.grey[800] : Colors.grey[300] | theme.colorScheme.surfaceContainerHighest |
| isDark ? Colors.grey[700] : Colors.grey[100] | theme.colorScheme.surfaceContainer |

### 3. استخدام cardTheme للـ Card Background

```dart
// صح — يعمل في Light و Dark تلقائياً
final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;

// غلط
final cardBg = isDark ? Color.alphaBlend(...) : Colors.white;
```

### 4. استخدام textTheme للنصوص

```dart
// صح — الـ textTheme بيتكيف مع الـ theme تلقائياً
style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp)
style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)

// غلط — hardcoded color
style: TextStyle(
  color: isDark ? Colors.white : Colors.black87,
  fontSize: 12.sp,
)
```

### 5. الـ Shimmer colors

```dart
// صح
baseColor: theme.colorScheme.surfaceContainerHighest,
highlightColor: theme.colorScheme.surfaceContainer,

// غلط
baseColor: theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!,
highlightColor: theme.brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[100]!,
```

---

## متى يُسمح بـ isDark؟

فقط في حالات استثنائية جداً لا يوفر فيها الـ colorScheme بديلاً مناسباً، مثلاً:
- تحديد opacity مختلف جداً بين الوضعين (مش مجرد لون).
- عند التعامل مع مكتبات خارجية لا تدعم الـ Theme مباشرة.

---

## ColorScheme Reference السريع

| Token | الاستخدام |
|-------|----------|
| colorScheme.primary | اللون الرئيسي — أزرار، روابط، CTAs |
| colorScheme.onPrimary | نص فوق خلفية primary |
| colorScheme.surface | خلفية الكارت / السطح |
| colorScheme.onSurface | نص فوق الـ surface — يحل محل Colors.black87 / Colors.white |
| colorScheme.onSurfaceVariant | نص ثانوي أفتح — يحل محل Colors.black54 / Colors.white60 |
| colorScheme.surfaceContainerHighest | Shimmer base color |
| colorScheme.surfaceContainer | Shimmer highlight color |
| colorScheme.outline | حدود / dividers |
| colorScheme.outlineVariant | حدود خفيفة |
| colorScheme.tertiary | لون تمييزي ثالث |
