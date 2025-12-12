import 'package:flutter/material.dart';

import 'package:hafzon/views/nav_bar/home/home.dart';
import 'package:hafzon/views/plan/plan_view.dart';
import 'more/more_page.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({
    super.key,
  });

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  int currentIndex = 0;
  List screens = [
    HomePage(),
    PlanView(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          unselectedItemColor: Colors.grey[800], // Dark Gray when not chosen
          selectedItemColor: Colors.grey, // Normal Gray when chosen
          items: const [
            BottomNavigationBarItem(
              tooltip: 'Surah',
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              label: '_____',
            ),
            BottomNavigationBarItem(
              tooltip: 'Plan',
              icon: Icon(
                Icons.calendar_today,
                size: 25,
              ),
              label: '_____',
            ),
            BottomNavigationBarItem(
              tooltip: 'Settings',
              icon: Icon(
                Icons.settings,
                size: 25,
              ),
              label: '_____',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          elevation: 10.0,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
