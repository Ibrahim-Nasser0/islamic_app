import 'package:material_ui/material_ui.dart';

/// Wraps the root application or screen to dismiss virtual keyboard when tapping anywhere outside
class AppUnfocus extends StatelessWidget {
  final Widget child;

  const AppUnfocus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
