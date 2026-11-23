# Android Platform Guidelines (Flutter Material 3)

> Material Design 3 engineering standards, Android design conventions, Cairo & Roboto typography, and native Flutter patterns for `menu_manager`.
> **Read this file when building or reviewing features for Android devices in Flutter.**

---

## 1. Material Design 3 Philosophy in Flutter

### Core Material Principles

```
MATERIAL AS METAPHOR:
├── Surfaces exist in 3D space with layered elevation
├── Light, gradients, and shadows define hierarchy
├── Motion and ripples provide continuity and tactile feedback
└── Bold, intentional typographic and spatial design

ADAPTIVE DESIGN:
├── One unified Flutter codebase adapted to phones, foldables, and tablets
├── Window Size Classes (Compact, Medium, Expanded)
├── Dynamic color extraction & theme extensions
└── Responsive metrics via ScreenUtil (.w, .h, .sp, .r)

ACCESSIBLE BY DEFAULT:
├── Mandatory 48dp × 48dp minimum touch targets
├── High contrast ratios (WCAG 2.1 AA / AAA)
├── TalkBack screen reader support via Semantics
└── Respects user motion & font scale preferences
```

### Material 3 Baseline Configuration

In Flutter, always ensure `useMaterial3: true` is configured in `ThemeData`:

```dart
ThemeData buildLightTheme(Locale locale) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    // ...
  );
}
```

---

## 2. Android Typography Scale (Flutter & Cairo/Roboto)

### Multi-Script Font Family Hierarchy

The app dynamically swaps the font family based on the active `locale`:
- **Arabic (`ar`)**: `GoogleFonts.cairo()`
- **English (`en`)**: `GoogleFonts.inter()` or `GoogleFonts.roboto()`

### Material Type Scale in Flutter

| Material 3 Role | Size (ScreenUtil) | Weight | Line Height | Usage |
|---|---|---|---|---|
| **Display Large** | `57.sp` | Regular / w400 | `64.sp` | Hero numbers, splash |
| **Display Medium** | `45.sp` | Regular / w400 | `52.sp` | Large KPI values |
| **Display Small** | `36.sp` | Bold / w800 | `44.sp` | Total Menu Views metric |
| **Headline Large** | `32.sp` | SemiBold / w600 | `40.sp` | Main page titles |
| **Headline Medium**| `28.sp` | SemiBold / w600 | `36.sp` | Primary section headers |
| **Headline Small** | `24.sp` | SemiBold / w600 | `32.sp` | Subsections |
| **Title Large** | `22.sp` | Bold / w700 | `28.sp` | Modal dialog titles |
| **Title Medium** | `16.sp` | Medium / w500 | `24.sp` | List titles, card titles |
| **Title Small** | `14.sp` | Medium / w500 | `20.sp` | Tab bars, badges |
| **Body Large** | `16.sp` | Regular / w400 | `24.sp` | Primary content |
| **Body Medium** | `14.sp` | Regular / w400 | `20.sp` | Descriptions, inputs |
| **Body Small** | `12.sp` | Regular / w400 | `16.sp` | Supporting captions |
| **Label Large** | `14.sp` | SemiBold / w600 | `20.sp` | Primary buttons (`CustomButton`) |
| **Label Medium** | `12.sp` | Medium / w500 | `16.sp` | Filter chips, pills |
| **Label Small** | `11.sp` | Medium / w500 | `16.sp` | Micro-badges, trends |

### Scale-Independent Pixels (`.sp`) & Font Scaling Rules

- **RULE 1**: Always use `fontSize: 14.sp` (ScreenUtil) for text so it scales with user display density and accessibility preferences.
- **RULE 2**: Never fix container heights tightly around text. Use `TextOverflow.ellipsis`, `maxLines`, or flexible layouts to prevent clipping when font scale increases up to 200%.

---

## 3. Material Color System & Zero-Conditional Theming

### Semantic Color Roles (`ColorScheme`)

```
SURFACE HIERARCHY:
├── surface: Main canvas background
├── surfaceContainerLowest / surfaceContainerLow: Layer 0
├── surfaceContainer: Cards and segmented controls
├── surfaceContainerHigh / surfaceContainerHighest: Floating elements
└── outline / outlineVariant: Hairline borders and dividers

ACTION COLORS:
├── primary: Key actions, FAB, active indicators
├── onPrimary: Text/icons on primary
└── secondary / tertiary: Accents, highlights, and trends
```

### Zero-Conditional Theme Policy (Rule 8 in `AGENTS.md`)

```dart
// ❌ HARD BAN: NEVER write inline conditional brightness checks in widgets
final bg = isDark ? Colors.black : Colors.white;
if (Theme.of(context).brightness == Brightness.dark) { ... }

// ✅ MANDATORY: Derive colors purely through Semantic Design Tokens
final customTheme = context.customTheme;
final heroTheme = context.heroTheme;
final planTheme = context.planTheme;
final colorScheme = Theme.of(context).colorScheme;

Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    border: Border.all(color: customTheme.cardBorder),
    boxShadow: [
      BoxShadow(color: customTheme.cardShadow, blurRadius: 16),
    ],
  ),
);
```

### Card Hierarchy & Lighting

```
TIER 1 (Hero Analytics Card - Total Menu Views):
├── Light: 3-Stop Electric Ice Gradient [#FFFFFF → #F0F7FF → #E0F2FE] + Sky border + Sapphire glow shadow
└── Dark: 3-Stop Cosmic Obsidian [#0B132B → #111C38 → #162544] + Neon Cyan border + Cyber glow shadow

TIER 2 (SaaS Subscription Tier - PlanCard):
├── Light: 3-Stop Pearlescent Amethyst Frost [#FFFFFF → #FAF5FF → #F3E8FF] + Royal Violet border & shadow
└── Dark: 3-Stop Cosmic Nebula [#16113A → #231145 → #2E1065] + Neon Violet border & glowing shadow

TIER 3 (Standard Operational Cards):
├── Light: Pure white surface (#FFFFFF) + Crisp hairline border (0x170F172A) + Floating soft shadow
└── Dark: Deep slate surface (#1E293B) + Subtle border (#334155) + Deep elevation shadow
```

---

## 4. Android Layout & Spacing (8dp Grid)

All layout metrics follow an 8dp baseline grid scaled through `ScreenUtil`:

```
4dp  (4.w / 4.h)   → Micro-spacing (inner chip padding, icon spacing)
8dp  (8.w / 8.h)   → Minimum component spacing
12dp (12.w / 12.h) → Dense card padding
16dp (16.w / 16.h) → Standard screen margins & form field vertical gaps
24dp (24.w / 24.h) → Section separation
32dp (32.w / 32.h) → Major flow breaks
```

### Window Size Classes

| Class | Width | Target Devices | Layout Pattern |
|---|---|---|---|
| **Compact** | `< 600dp` | Phones (Portrait) | Single column, `MorphingNavBar` / Bottom navigation |
| **Medium** | `600–840dp` | Foldables, Mini Tablets | 2 columns or master-detail split |
| **Expanded**| `> 840dp` | Large Tablets, Desktop | Multi-pane layout, persistent side navigation rail |

---

## 5. Android Navigation & Predictive Back in Flutter

### Predictive Back Gestures (`PopScope`)

Modern Android 14+ devices rely on predictive back gesture animations. Never use the deprecated `WillPopScope`. Always use `PopScope`:

```dart
PopScope(
  canPop: !hasUnsavedChanges,
  onPopInvokedWithResult: (didPop, result) async {
    if (didPop) return;
    final shouldLeave = await _showDiscardConfirmDialog(context);
    if (shouldLeave && context.mounted) {
      Navigator.of(context).pop();
    }
  },
  child: Scaffold(...),
);
```

### Centralized Routing (`AppRouter`)

All navigation transitions must use `Navigator.pushNamed(context, Routes.xxx, arguments: ...)`. Never use ad-hoc `MaterialPageRoute` inline.

---

## 6. Material 3 Components (Core Custom Widgets)

To guarantee 100% Android UI consistency, always use the project's core widgets from `lib/core/widgets/`:

### A. Primary Buttons (`CustomButton`)
- Meets the 48dp touch target standard (default `height: 56.h`).
- Micro-scale tap feedback with `.buttonAnimation()`.
- Built-in loading indicator without layout shifts.

### B. Form Input Fields (`CustomTextField`)
- Uses M3 `InputDecorationTheme` with crisp 1.0px hairline borders.
- Floating label animation.
- Tap-to-unfocus handled automatically (`AppUnfocus` root wrapper).

### C. Segmented Controls (`CustomSegmentedControl`)
- Animated sliding pill indicator with `AppHaptics.selection()`.
- Replaces raw `TabBar` for filters and sub-tabs.

---

## 7. Native Android Patterns & Micro-Interactions

### A. Material Ripple Effect
Every clickable container or list tile must provide a Material ripple with bounded or unbounded clipping:

```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(12.r),
    onTap: () {
      AppHaptics.light();
      onAction();
    },
    child: Padding(
      padding: EdgeInsets.all(12.w),
      child: content,
    ),
  ),
);
```

### B. Tactile Micro-Interactions (`AppHaptics`)
Every touch gesture on Android must invoke physical tactile haptic feedback:
- `AppHaptics.light()`: Segment clicks, icon options, filter pills.
- `AppHaptics.selection()`: Tab bar switches, picker changes.
- `AppHaptics.medium()`: FAB actions, primary form submission buttons.
- `AppHaptics.heavy()`: Destructive actions, reset confirmations.

### C. Bottom Sheets (`showCustomBottomSheet`)
- Rounded top corners (`24.r`).
- Standard drag handle (`40.w × 4.h`).
- Automatic keyboard dismissal and `viewInsets` padding.

### D. Pull-To-Refresh (`AppRefreshIndicator`)
- Custom animated Mot7km branded spinner.
- Haptic trigger feedback and iOS/Android physics overscroll.

---

## 8. Material Symbols & Iconography

- Standard sizes: `16.sp` (dense), `20.sp` (inline), `24.sp` (actions & app bars), `40.sp` / `48.sp` (empty states & hero icons).
- Coloration derived from `Theme.of(context).colorScheme.primary` or `context.customTheme.textSecondary`.

---

## 9. Android Accessibility & TalkBack in Flutter

### TalkBack Semantics
All interactive icons and custom cards without text labels must have `Semantics`:

```dart
Semantics(
  button: true,
  label: 'filter_by_week'.tr(),
  child: HeroMetricFilterPill(...),
);
```

### 48dp Minimum Touch Target Size
Even if an icon or button is visually 24dp, its interactive touch area must be at least `48dp × 48dp`:

```dart
IconButton(
  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
  icon: Icon(Icons.more_vert, size: 24.sp),
  onPressed: () {},
);
```

### Reduce Motion Preference
Respect user system animation scale:

```dart
final disableAnimations = MediaQuery.of(context).disableAnimations;
final animDuration = disableAnimations ? Duration.zero : const Duration(milliseconds: 300);
```

---

## 10. Android Release Checklist

### Before Every Android Screen
- [ ] Uses Material 3 components and project core widgets.
- [ ] Zero `isDark` or `Brightness.dark` conditionals in widgets (Rule 8).
- [ ] Interactive touch targets are $\ge 48\text{dp} \times 48\text{dp}$.
- [ ] Material ripple (`InkWell`) paired with `AppHaptics`.
- [ ] Typography uses `.sp` with Cairo/Roboto and supports 200% scaling without clipping.
- [ ] Back navigation handled with `PopScope`.
- [ ] All user-facing strings localized symmetrically via `easy_localization` (`.tr()`).
- [ ] File length strictly $\le 200$ lines (Rule 7).

### Before Android App Release
- [ ] Edge-to-Edge display tested across light and dark themes.
- [ ] Dynamic color contrast verified (WCAG AA).
- [ ] TalkBack navigation tested with screen reader.
- [ ] Predictive back gesture verified on Android 14+.
- [ ] Foldables & tablet multi-window tested.
