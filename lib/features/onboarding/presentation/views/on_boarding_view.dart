import 'package:material_ui/material_ui.dart';
import 'package:islamic_app/features/onboarding/presentation/views/widgets/on_boarding_body.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const OnBoardingBody(),
    );
  }
}
