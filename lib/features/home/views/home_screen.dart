import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/navbar/morphing_nav_bar.dart';
import 'widgets/ahadith_tab_view.dart';
import 'widgets/azkar_tab_view.dart';
import 'widgets/home_prayer_view.dart';
import 'widgets/quran_tab_view.dart';

/// Main Application Shell Screen with Custom AppBar and Morphing NavBar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomePrayerView(),
    QuranTabView(),
    AzkarTabView(),
    AhadithTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: MorphingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          NavItem(
            icon: Icons.mosque_outlined,
            activeIcon: Icons.mosque_rounded,
            label: 'home'.tr(),
          ),
          NavItem(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book_rounded,
            label: 'quran'.tr(),
          ),
          NavItem(
            icon: Icons.favorite_outline_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'azkar'.tr(),
          ),
          NavItem(
            icon: Icons.auto_stories_outlined,
            activeIcon: Icons.auto_stories_rounded,
            label: 'ahadeth'.tr(),
          ),
        ],
      ),
    );
  }
}
