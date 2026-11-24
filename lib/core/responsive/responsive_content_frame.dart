import 'package:material_ui/material_ui.dart';

import 'window_size_class.dart';

/// Centers and constrains child content on wide screens using [LayoutBuilder].
/// On compact screens the child fills the available width.
class ResponsiveContentFrame extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContentFrame({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMax = maxWidth ?? context.contentMaxWidth;
    final gutter = context.horizontalGutter;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= effectiveMax) {
          return Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: gutter),
            child: child,
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: effectiveMax),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: gutter),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
