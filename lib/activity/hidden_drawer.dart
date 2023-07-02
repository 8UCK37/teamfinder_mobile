import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';
import 'package:teamfinder_mobile/activity/profile_screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pages = [
      ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'HomePage', 
        baseStyle: TextStyle(), 
        selectedStyle: TextStyle()
        ), 
      HomeScreenWidget()),

      ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'ProfilePage', 
        baseStyle: TextStyle(), 
        selectedStyle: TextStyle()
        ), 
      ProfilePage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple.shade300,
      screens: _pages,
      initPositionSelected: 0,
    );
  }
}
