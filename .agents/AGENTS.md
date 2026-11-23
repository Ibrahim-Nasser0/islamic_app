# Project Rules & Development Guidelines (AGENTS.md)

This document defines the mandatory design, architecture, and coding guidelines for the `menu_manager` SaaS ERP project. All developers and AI coding assistants MUST strictly follow these rules.

---

## 1. Mandatory Core Custom Widgets Usage 🧩

To maintain 100% UI consistency across the app, **NEVER** build ad-hoc dialogs, bottom sheets, buttons, or segmented controls using default Flutter widgets. Always use the project's core custom widgets from `lib/core/widgets/`:

### A. Bottom Sheets (Unified `showCustomBottomSheet` Standard) 📑
- **Strict Architecture Rule**:
  - ALL bottom sheets MUST be opened via `showCustomBottomSheet<T>(context: context, child: ...)` from `lib/core/widgets/custom_bottom_sheet.dart`.
  - **NEVER** wrap the inner child widget in `CustomBottomSheetContainer` when displayed via `showCustomBottomSheet()`.
  - **Why**: `showCustomBottomSheet()` ALREADY wraps the provided `child` inside `CustomBottomSheetContainer`. Wrapping the child again causes harmful **double nesting**: duplicate drag handles, double animations, and corrupted keyboard padding (`bottomInset`).
- **How to Build the Inner Sheet Widget**:
  - The sheet widget (e.g. `QuickAddCategoryBottomSheet`, `DeleteAccountSheet`) should simply return a scrollable/padded structure: `Padding(...)` wrapping `SingleChildScrollView(child: Column(...))` or `Form(...)`.
  - Do NOT manually build drag handle bars inside the child widget; `CustomBottomSheetContainer` automatically injects the standard drag handle (`showDragHandle: true`).
- **Features Handled Automatically by `showCustomBottomSheet`**:
  - Automatic virtual keyboard unfocus (`FocusScope.of(context).unfocus()`).
  - Animated keyboard inset tracking (`MediaQuery.of(context).viewInsets.bottom`).
  - Standardized surface background and top rounded corners (`24.r`).
  - Standardized drag handle and entry animation (`fade + slideY`).
- **Location**: `lib/core/widgets/custom_bottom_sheet.dart`

### B. Segmented Controls / Tab Pickers
- **Rule**: ALL binary or multi-option style selectors MUST use `CustomSegmentedControl`.
- **Location**: `lib/core/widgets/custom_segmented_control.dart`
- **Features**: Animated sliding pill indicator (`AnimatedAlign`), dark/light theme support, and automatic haptic click feedback (`AppHaptics.selection()`).

### C. Input Fields, Text Controllers & Keyboard Unfocus ⌨️
- **Rule**: ALL form input fields MUST use `CustomTextField`. NEVER use raw `TextField` or `TextFormField` in forms.
- **Location**: `lib/core/widgets/custom_text_field.dart` & `lib/core/widgets/app_unfocus.dart`
- **Automatic Tap-To-Unfocus**:
  - `CustomTextField` MUST internally handle `onTapOutside` defaulting to `FocusManager.instance.primaryFocus?.unfocus()`.
  - The root application in `main.dart` (`MaterialApp.builder`) MUST wrap the content in `AppUnfocus` to ensure tapping anywhere on the screen dismisses the virtual keyboard.
  - Scrollable form views (`SingleChildScrollView`, `ListView`) MUST specify `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`.
- **Features**: Standardized labels, hints, prefix/suffix icons, borders, automated tap-to-unfocus, and error validation formatting.

### D. Buttons & Tap Animations
- **Rule**: ALL primary action buttons MUST use `CustomButton` paired with the `.buttonAnimation()` extension for micro-scale feedback.
- **Location**: `lib/core/widgets/custom_button.dart` & `lib/core/widgets/animations/button_animation.dart`

### E. Toggle Switches
- **Rule**: ALL toggle switches MUST use `CustomSwitcherTile` or `CustomSwitcherButton`.
- **Location**: `lib/core/widgets/custom_switcher_tile.dart`

### F. Dialogs & Alerts (Unified `AppDialogs` Standard) 📢
- **Strict Prohibitions**:
  - **NEVER** instantiate or use `CustomDialog` directly. `CustomDialog` in `lib/core/widgets/custom_dialog.dart` is a deprecated legacy adapter that only forwards to `CustomSuccessDialog` and drops custom icons/colors. Direct instantiation or calling `showDialog(builder: (_) => CustomDialog(...))` is **STRICTLY FORBIDDEN**.
  - **NEVER** call `showDialog` with raw Flutter `AlertDialog` or directly instantiate inner dialog widgets (`CustomSuccessDialog`, `CustomFailureDialog`, `CustomLoadingDialog`, `CustomConfirmDialog`).
- **Mandatory Usage (`AppDialogs` as Single Point of Truth)**:
  - ALL dialog interactions across the entire codebase MUST be dispatched through the static helper methods in `AppDialogs` (`lib/core/utils/dialogs.dart`):
    1. `AppDialogs.loading(context, title: ..., message: ...)`: Shows the frosted glass loading dialog with the kinetic Mot7km spinner. Manages `_isLoadingOpen` state.
    2. `AppDialogs.hide(context)`: Safely dismisses the currently open loading dialog. ALWAYS call before presenting success or error dialogs.
    3. `AppDialogs.success(context, title: ..., message: ..., popScreen: bool, result: ...)`: Displays the frosted glass success dialog with emerald checkmark, tactile haptics, and non-dismissible barrier (`barrierDismissible: false`). For full-screen forms, set `popScreen: true` (see Rule 1.I).
    4. `AppDialogs.error(context, title: ..., message: ..., failure: ..., onRetry: ...)` / `AppDialogs.failure(...)`: Displays `CustomFailureDialog` with automated `FailureType` resolution (Network, Server, Auth, Validation), technical details, and optional retry action.
    5. `AppDialogs.confirm(context, title: ..., message: ..., confirmText: ..., cancelText: ...)`: Displays `CustomConfirmDialog` with Amber glow and returns `Future<bool?>`.
- **Location**: `lib/core/utils/dialogs.dart` & `lib/core/widgets/dialogs/` (`dialogs.dart`).

### G. Loading Indicators & Skeletons
- **Rule**: ALL feature loading states MUST use skeleton/shimmer placeholders (`CustomSkeleton` / `shimmer`), NEVER default `CircularProgressIndicator` or raw progress indicators.
- **Location**: `lib/core/widgets/custom_skeleton.dart`

### H. Pull-To-Refresh Indicators
- **Rule**: ALL scrollable views that support pull-to-refresh MUST use `AppRefreshIndicator`, NEVER default Flutter `RefreshIndicator`.
- **Location**: `lib/core/widgets/app_refresh_indicator.dart`
- **Features**: Branded Mot7km logo with continuous rotation and pulse animations, dynamic gesture tracking, tactile haptic feedback (`AppHaptics.light()` & `AppHaptics.medium()`), and seamless iOS rubber-band physics integration.

### I. Mandatory Form Submission & Success Lifecycle Rule 🔄
- **No Auto-Dismissing Forms**: NEVER close a creation or editing view automatically using arbitrary `Future.delayed()`. Every completed form submission MUST present a confirmed success dialog via `AppDialogs.success()`.
- **Explicit User Acknowledgment**: Success dialogs MUST NEVER auto-dismiss. They remain on screen until the user explicitly taps "تم" (`'ok'.tr()`). The barrier dismissibility (`barrierDismissible`) is strictly disabled (`false`).
- **Synchronized Screen Dismissal (`popScreen: true`)**: For full-screen forms (e.g. Add Product, Add Category, Add Slider Banner, Profile Setup), ALWAYS pass `popScreen: true` to `AppDialogs.success(context, ..., popScreen: true)`. NEVER call `Navigator.pop(context)` inside an `onPressed` callback synchronously alongside dialog dismissal, as this causes Flutter Navigator race collisions leaving the screen open.
- **Clean Loading-to-Success Transition**: ALWAYS dismiss active loading dialogs via `AppDialogs.hide(context)` BEFORE presenting `AppDialogs.success(...)`. NEVER call `AppDialogs.hide()` in subsequent cubit states that destroy an active success dialog.

### J. Mandatory Destructive Actions & Deletion Confirmation Rule 🗑️⚠️
- **Zero Silent Deletions**: NEVER execute a deletion or destructive operation (deleting a category, product, banner, customization, ingredient, or account) directly upon a user tap or without prior user confirmation.
- **Mandatory Warning Dialog**: ALL destructive actions across the application MUST present a warning confirmation dialog dispatched strictly through `AppDialogs.confirm(...)`:
  - `icon`: `Icons.delete_outline_rounded` or `Icons.warning_amber_rounded`.
  - `iconColor`: `AppColors.error` (or `Color(0xFFEF4444)`).
  - `confirmText`: `'delete'` (translated standard key).
  - `cancelText`: `'cancel'` (translated standard key).
  - `confirmButtonColor`: `const Color(0xFFEF4444)` (danger red solid pill).
  - `message`: Contextual, descriptive warning indicating the specific item name and impact (e.g. indicating whether sub-items like products in a category will be affected).
- **Physical Tactile Feedback**: All deletion trigger actions MUST invoke `AppHaptics.heavy()`.
- **Cancellation Safety**: If the user dismisses the dialog or taps "Cancel", NO state change, deletion cubit method, or API call must be executed.
- **Successful Deletion Feedback**: Upon confirmed deletion, the item must be removed from the UI and confirmed with a clear feedback message (`AppDialogs.success` or cubit `successMessage`).

### K. Filter & Popover Dropdown Menus (Unified `CustomFilterDropdown` Standard) 🔽
- **Strict Architecture Rule**: ALL contextual filter dropdowns, time-range selectors, sorting pickers, and popover menus MUST use `CustomFilterDropdown<T>` from `lib/core/widgets/custom_filter_dropdown.dart`. **NEVER** use raw Flutter `PopupMenuButton`, `DropdownButton`, or ad-hoc popups in presentation code.
- **Tight Intrinsic Content-Fitting**: The menu MUST wrap strictly around the text and icon content (`constraints: const BoxConstraints(minWidth: 0)`), eliminating all excessive empty margins and default Flutter minimum widths.
- **Capsule Pill Highlight (Zero Checkmark Clutter)**: The active/selected option MUST be rendered as an elegant highlighted capsule pill (`theme.colorScheme.primary.withValues(alpha: 0.12)`) with bold active typography. **NEVER** add checkmark icons to items; the capsule pill background is the single, clear active state indicator.
- **Tactile Feedback & Zero Theme Conditionals**: Automatic haptic feedback (`AppHaptics.light()` on open, `AppHaptics.selection()` on pick), hairline border (`customTheme.cardBorder`), soft ambient elevation shadow (`customTheme.cardShadow`), and strict zero-`isDark` compliance.
- **Location**: `lib/core/widgets/custom_filter_dropdown.dart`

---

## 2. Strict Localization Standards (EasyLocalization) 🌐

- **NO Hardcoded Strings**: ALL user-facing text strings MUST be localized. Never hardcode Arabic or English strings directly in presentation widgets.
- **Symmetric Keys**: Any key added to `assets/lang/ar.json` MUST be symmetrically added with proper translation to `assets/lang/en.json`.
- **Extension Syntax**: Always use the `.tr()` string extension (e.g. `'business_profile'.tr()`).

---

## 3. Tactile Micro-Interactions (Haptic Feedback) 📳

- **Rule**: ALL interactive elements MUST provide physical tactile feedback using the `AppHaptics` helper class (`lib/core/utils/haptics.dart`):
  - `AppHaptics.light()`: Bottom sheet options, action tiles, quick card toggles.
  - `AppHaptics.selection()`: Tab bar switches, segmented control changes, color palette selections.
  - `AppHaptics.medium()`: Floating action buttons (FAB), primary form submissions.
  - `AppHaptics.heavy()`: Destructive actions (deletions, reset).

---

## 4. Clean Architecture & MVVM (BLoC / Cubit) Rules 🏗️

- **Layer Separation**:
  - `domain/`: Entities, Repository Contracts, and UseCases (Pure Dart).
  - `data/`: Models (JSON), DataSources, and Repository Implementations.
  - `presentation/`: Cubit & State (ViewModel), Views, and Modular Widgets.
- **No Ad-Hoc Controller Classes**:
  - NEVER create plain Dart controller classes (e.g. `FormController`, `WorkingHoursController`) to hold state or logic.
  - State management MUST strictly use **Cubit/BLoC** following MVVM principles. If a feature or sub-flow requires state, create a dedicated `Cubit` (e.g., `WorkingHoursCubit`, `BranchesCubit`).
- **Dependency Injection (GetIt)**:
  - ALL DataSources, Repositories, UseCases, and Cubits MUST be registered in `lib/core/di/injection_container.dart`.
- **Rebuild Optimization**:
  - ALWAYS use `buildWhen` in `BlocBuilder` and `context.select` to prevent unnecessary widget rebuilds when unrelated states change.

---

## 5. Navigation & Screen Routing 🛣️

- **Full-Screen Views**: Large creation or management forms (e.g., Add Product, Add Category, Add Slider Banner, Business Profile) MUST be dedicated full-screen views, NOT bottom sheets.
- **Route Registration**: New views MUST define a constant in `Routes` (`lib/core/routes/routes.dart`) and register in `AppRouter` (`lib/core/routes/app_router.dart`) with smooth transition animations.
- **No Raw Widget Navigation**: ALL screen transitions MUST pass through `Navigator.pushNamed(context, Routes.xxx, arguments: ...)` using `AppRouter`. Never use `MaterialPageRoute(builder: (context) => SomeWidget())`.

---

## 6. Design System & Theme Rules 🎨

- **Responsive Metrics**: Always wrap numeric layout dimensions in `ScreenUtil` extensions (`.w`, `.h`, `.sp`, `.r`).
- **Theme Color Palette**: Derive colors from `Theme.of(context)` and `AppColors` to support seamless Dark/Light Mode switching.

---

## 7. Strict File Size Limit (Max 200 Lines) 📏

- **Rule**: NO file in the codebase should exceed **200 lines of code**.
- **Action**: When building or refactoring screens, views, or widgets, extract sub-widgets, form sections, or modular helpers into separate dedicated files to keep every file strictly under 200 lines.

---

## 8. Zero-Conditional Theme Policy (Strictly NO `isDark` in Presentation Code) 🚫🌓

- **Rule**: NEVER write `if (isDark)`, `isDarkMode ? ... : ...`, or `theme.brightness == Brightness.dark` in presentation widgets or UI components.
- **Why**: Inline theme conditional checks fragment design consistency, lead to brittle and unmaintainable code, and cause visual regressions between light and dark modes.
- **Mandatory Approach (Semantic Design Tokens)**:
  - ALL colors, borders, shadows, and backgrounds in presentation widgets MUST be derived purely from:
    1. `Theme.of(context).colorScheme` (Standard Material 3 tokens: `surface`, `onSurface`, `primary`, `outline`, `error`, etc.).
    2. `context.appColors` / `context.customTheme` (`AppThemeColors` extension for semantic tokens like `cardBorder`, `cardShadow`, `surfaceSubtle`, `badgeBackground`, `statusActiveBg`, etc.).
    3. `context.heroTheme` (`HeroCardThemeTokens` extension for hero metric cards and banners).
    4. Theme component defaults configured in `lib/core/theme/` (`cardTheme`, `inputDecorationTheme`, etc.).
  - **Adding New Tokens**: If a UI component requires adaptive styling not yet represented, developers/AI MUST define the token in `AppThemeColors` or a specialized `ThemeExtension` in `lib/core/theme/` instead of adding inline conditionals in widgets.

---

## 9. Subtle Visual Aesthetics (Strictly NO Harsh or Exaggerated Glow) 🚫✨

- **Rule**: NEVER apply harsh, overly saturated neon glows, intense radial halos, or exaggerated blooming drop shadows to UI components, cards, navigation bars, buttons, or badges.
- **Why**: `menu_manager` is a business-grade SaaS ERP platform for merchants and enterprise users. Heavy neon blooms, aggressive colored halos, and intense glowing shadows degrade usability, cause eye fatigue, and detract from a refined, premium aesthetic.
- **Mandatory Guidelines**:
  - **Restrained Ambient Shadows**: All elevation shadows MUST be soft, diffused, and low-opacity (alpha $\le 10\text{--}15\%$ in Light Mode, $\le 20\text{--}25\%$ in Dark Mode). Avoid high-opacity colored shadows that bleed into adjacent components.
  - **Crisp Structural Depth**: Build visual hierarchy through clean surface contrast, crisp hairline borders (`0.8px` to `1.0px`), and elegant multi-stop gradients rather than radiant glows.
  - **Professional SaaS Aesthetic**: Maintain a world-class, clean, and understated design language (inspired by Stripe, Linear, and Apple) rather than arcade, sci-fi, or cyberpunk neon styling.

