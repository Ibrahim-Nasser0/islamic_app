import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

/// Arranges [children] into a single column below [twoColumnBreakpoint]
/// and paired columns at or above [twoColumnBreakpoint].
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double twoColumnBreakpoint;
  final double horizontalSpacing;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.twoColumnBreakpoint = 560,
    this.horizontalSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < twoColumnBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += 2) {
          final hasSecond = i + 1 < children.length;
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: children[i]),
                Gap(horizontalSpacing),
                Expanded(
                  child: hasSecond ? children[i + 1] : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
