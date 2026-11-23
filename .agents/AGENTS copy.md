# Project Guidelines & Architecture Rules (Mot7km POS)

## 1. Clean Architecture & Feature-First Structure

Each feature MUST follow Clean Architecture principles separated by layers:
- **`data/`**: DataSources (Remote/Local), Models (with JSON serialization), Repository Implementations.
- **`domain/`**: Entities, Repository Interfaces, Usecases (if needed).
- **`presentation/`**: 
  - `bloc/` or `cubit/`: UI logic & State management using `flutter_bloc`.
  - `views/mobile/` & `views/desktop/`: Layout entry points.
  - `widgets/mobile/` & `widgets/desktop/`: Feature-specific reusable UI components.

---

## 2. Full Adaptive UI Architecture Standard

When implementing or refactoring UI components for features, **DO NOT** rely solely on inline conditional checks inside monolithic widget files. Follow the **Full Adaptive Architecture**:

### Directory Structure Requirements
Inside each feature's `presentation` layer:
- `views/mobile/`
- `views/desktop/`
- `widgets/mobile/`
- `widgets/desktop/`

### Main View Dispatcher
The main feature entry point `View` (e.g. `LoginView`, `PosCheckoutView`) should act as an adaptive layout dispatcher using `LayoutBuilder`:
```dart
return LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 900;
    if (isMobile) {
      return const FeatureMobileLayout();
    }
    return const FeatureDesktopLayout();
  },
);
```

---

## 3. Screen Scaling & Spacing (`flutter_screenutil` + `gap`)

- **Spacing Standard**: ALWAYS use `Gap` from `package:gap` instead of `SizedBox` for horizontal/vertical spacing between widgets (e.g. `Gap(12.h)`, `Gap(16.w)`).
- **Responsive Dimensions**: All dimensions, typography, padding, margins, icon sizes, and border radii MUST use `flutter_screenutil` extensions:
  - **Width / Horizontal Spacing**: `.w` (e.g. `16.w`, `Gap(12.w)`)
  - **Height / Vertical Spacing**: `.h` (e.g. `24.h`, `Gap(20.h)`)
  - **Font Sizes**: `.sp` (e.g. `fontSize: 16.sp`)
  - **Border Radius**: `.r` (e.g. `BorderRadius.circular(16.r)`)
  - **Icon / Square Sizes**: `.r` or `.w` (e.g. `Icon(Icons.star, size: 24.r)`)

---

## 4. File Sizing & Modularization Standard

- **File Length Limits**: Each Dart file MUST be kept modular and readable, aiming for **140 to 260 lines maximum**.
- **Refactoring Requirement**: If any UI widget or logic file exceeds 260 lines, split it into smaller dedicated sub-widgets or sub-components inside the `widgets/` directory.

---

## 5. Third-Party Package Usage Standard

- **Avoid Reinventing the Wheel**: ALWAYS prioritize using established, well-maintained packages (e.g., `gap`, `shimmer`, `cached_network_image`, `flutter_svg`, `animate_do`, `lottie`, `file_picker`) for UI effects, loading states, and media instead of building custom implementations from scratch.

---

## 6. State Management & Error Handling Standard (`flutter_bloc` + `dartz`)

- **Separation of Concerns**: UI widgets MUST NOT contain business logic or API calls directly. All logic belongs to BLoC/Cubit.
- **Immutable States**: All States MUST extend `Equatable` to prevent unnecessary UI rebuilds.
- **Functional Error Handling (`dartz`)**:
  - Repositories MUST return `Future<Either<Failure, T>>`.
  - Data sources catch exceptions and throw custom `Exceptions`.
  - Repositories catch `Exceptions` and map them to user-friendly `Failure` objects (e.g. `ServerFailure`, `NetworkFailure`).

---

## 7. Dependency Injection & Routing (`get_it` + `go_router`)

- **Service Locator (`get_it`)**: All BLoCs, Repositories, DataSources, and Services MUST be registered via `GetIt`. Never instantiate dependencies directly inside widgets.
- **Navigation (`go_router`)**: All screen transitions MUST use `GoRouter`. Avoid raw `Navigator.push` or `Navigator.pop` unless manipulating local dialogs/overlays.

---

## 8. UI Performance & Clean Code Best Practices

- **Use `const` Constructors**: Always use `const` for widgets and constructors whenever possible to optimize Flutter's render tree.
- **Resource Management**: Always dispose `Controllers` (`TextEditingController`, `ScrollController`, `AnimationController`, `StreamSubscription`) when widgets are unmounted.
- **No Heavy Operations in `build()`**: Never execute data fetching, parsing, or heavy calculations inside widget `build()` methods.

---

## 9. UI, Theme & Design Standards (`AppTheme` & `AppColors`)

- **Centralized Theme**: ALWAYS rely on `AppTheme`, `AppColors`, and `Theme.of(context)` for styling. DO NOT hardcode raw `Color(0xFF...)`, raw custom text styles, or ad-hoc decorations when centralized theme properties exist.
- **Aesthetics**: Use high-quality design aesthetics: sleek dark gradients, glassmorphism, subtle card shadows, smooth transitions (`animate_do`), clear typography, and vibrant status/theme colors.
- **Mobile Layouts**: Touch-optimized with accessible action buttons, clean scrolling, and responsive bottom sheets or modals.
- **Desktop Layouts**: Wide screen utilization (multi-column), side hero panels, hover states, and keyboard shortcuts.

---

## 10. Internationalization & Localization Standard (`easy_localization`)

- **DO NOT** use inline ternary checks like `isArabic ? '...' : '...'` for UI text strings anywhere in the codebase.
- **ALWAYS** use `easy_localization` translation keys with `.tr()` extension method (e.g. `'no_items_in_category'.tr()`, `'add_new_item'.tr()`, `'save_changes'.tr()`).
- All translation keys **MUST** be defined in the localization JSON asset files (`assets/lang/ar.json` and `assets/lang/en.json`).

---

## 11. Multi-Breakpoint Responsive Sizing Standard (`AppResponsive`)

When calculating dynamic sizes or values across screen breakpoints (Mobile, Tablet, Desktop, Large Desktop, XLarge Desktop), ALWAYS use `AppResponsive` with Dart 3 `switch` expressions or `AppResponsive.value<T>()`:

```dart
final avatarSize = switch (AppResponsive.getDesignSize(screenWidth)) {
  AppResponsive.mobileDesignSize => 56.r,
  AppResponsive.tabletDesignSize => 64.r,
  AppResponsive.desktopDesignSize => 70.r,
  AppResponsive.largeDesktopDesignSize => 75.r,
  AppResponsive.xlargeDesktopDesignSize => 80.r,
  _ => 65.r,
};
```

Or using the generic `AppResponsive.value<T>()` helper:
```dart
final avatarSize = AppResponsive.value<double>(
  screenWidth,
  mobile: 56.r,
  tablet: 64.r,
  desktop: 70.r,
  largeDesktop: 75.r,
  xlargeDesktop: 80.r,
);
```

DO NOT use messy inline ternary chains or ad-hoc raw conditional statements inside `build()` methods for breakpoint sizing.

---

## 12. Global App Padding & Sizing Standard (POS Benchmark)

To maintain UI consistency across all features, follow these standardized spacing and padding benchmarks:

### Outer Screen Padding (`AppResponsive.screenPadding(width)`)
- **Mobile**: `EdgeInsets.all(12.r)`
- **Tablet**: `EdgeInsets.all(16.r)`
- **Desktop**: `EdgeInsets.all(20.r)`

### Inner Card Content Padding (`AppResponsive.cardPadding(width)`)
- **Mobile**: `EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h)`
- **Tablet**: `EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h)`
- **Desktop**: `EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h)`

### Grid Card Spacing (`AppResponsive.gridSpacing(width)`)
- **Mobile Grid**: `12.w` horizontal, `12.h` vertical spacing
- **Tablet Grid**: `14.w` horizontal, `14.h` vertical spacing
- **Desktop Grid**: `16.w` horizontal, `16.h` vertical spacing

### Element Gaps (`Gap` from `package:gap`)
- **Micro Gap**: `Gap(4.w)` / `Gap(4.h)`
- **Small Gap**: `Gap(8.w)` / `Gap(8.h)`
- **Medium Gap**: `Gap(12.w)` / `Gap(12.h)`
- **Large Gap**: `Gap(16.w)` / `Gap(16.h)`
