import 'package:material_ui/material_ui.dart';

/// Material 3 window size classes for adaptive layouts.
enum WindowSizeClass {
  /// Phones < 600dp width.
  compact,

  /// Foldables & small tablets 600–839dp.
  medium,

  /// Large tablets & desktops >= 840dp.
  expanded,
}

/// Pure extension on [BuildContext] providing adaptive layout helpers.
/// Zero `isDark` — layout only, no theme conditionals.
extension WindowSizeExtension on BuildContext {
  /// Resolves the current [WindowSizeClass] from logical pixel width.
  WindowSizeClass get windowSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 840) return WindowSizeClass.expanded;
    if (width >= 600) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  /// True when NavigationRail should be displayed instead of bottom capsule.
  bool get usesNavRail => windowSize != WindowSizeClass.compact;

  /// True when device shortest side >= 600dp (tablet-class).
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;

  /// True when width > height.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// True when width < 360dp (very narrow phones or split-screen).
  bool get isNarrowPhone => MediaQuery.sizeOf(this).width < 360;

  /// Maximum content width to center on wide screens.
  double get contentMaxWidth {
    switch (windowSize) {
      case WindowSizeClass.expanded:
        return 1120;
      case WindowSizeClass.medium:
        return 680;
      case WindowSizeClass.compact:
        return double.infinity;
    }
  }

  /// Horizontal gutter for content frame.
  double get horizontalGutter {
    switch (windowSize) {
      case WindowSizeClass.expanded:
        return 32;
      case WindowSizeClass.medium:
        return 24;
      case WindowSizeClass.compact:
        return isNarrowPhone ? 12 : 16;
    }
  }

  /// Dynamic bottom clearance for floating bottom nav on compact screens,
  /// or standard bottom inset padding when using the side rail.
  double bottomNavClearance({double navBarHeight = 76}) {
    final systemBottom = MediaQuery.paddingOf(this).bottom;
    if (usesNavRail) {
      return systemBottom + 24;
    }
    return navBarHeight + systemBottom + 20;
  }
}
