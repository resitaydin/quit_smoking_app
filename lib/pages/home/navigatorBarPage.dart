import 'package:flutter/material.dart';
import 'package:loginui/pages/health/UnsmokedGrid.dart';
import 'package:loginui/pages/health_ach/AchievementList.dart';
import 'package:loginui/pages/home/MainPage.dart';
import 'package:loginui/pages/settings/settings_page.dart';
import 'package:loginui/pages/social/post_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NavigatorBarPage extends StatefulWidget {
  const NavigatorBarPage({super.key});
  @override
  State<NavigatorBarPage> createState() => _NavigatorBarPageState();
}

class _NavigatorBarPageState extends State<NavigatorBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainPage(),
    AchievementList(),
    const UnsmokedGrid(),
    SettingsPage(),
    const PostScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_currentIndex], // Use _pages[] to switch pages
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            const BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Health',
              icon: Icon(MdiIcons.heartPulse),
            ),
            BottomNavigationBarItem(
              label: 'Achievements',
              icon: Icon(MdiIcons.trophy),
            ),
            const BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
            const BottomNavigationBarItem(
              label: 'Community',
              icon: Icon(Icons.message),
            ),
          ],
        ),
      ),
    );
  }
}
