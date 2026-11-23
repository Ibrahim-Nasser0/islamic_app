import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
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
            icon: FlutterIslamicIcons.mosque,
            activeIcon: FlutterIslamicIcons.solidMosque,
            label: 'home'.tr(),
          ),
          NavItem(
            icon: FlutterIslamicIcons.quran2,
            activeIcon: FlutterIslamicIcons.solidQuran2,
            label: 'quran'.tr(),
          ),
          NavItem(
            icon: FlutterIslamicIcons.prayer,
            activeIcon: FlutterIslamicIcons.solidPrayer,
            label: 'azkar'.tr(),
          ),
          NavItem(
            icon: FlutterIslamicIcons.mohammad,
            activeIcon: FlutterIslamicIcons.solidMohammad,
            label: 'ahadeth'.tr(),
          ),
        ],
      ),
    );
  }
}
