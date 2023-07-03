import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';
import 'package:teamfinder_mobile/activity/profile_screen.dart';

import '../reusable_widgets/elevated_buttons.dart';
import '../services/auth_service.dart';

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
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'HomePage',
              baseStyle: TextStyle(),
              selectedStyle: TextStyle()),
          HomeScreenWidget()),
      
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'ProfilePage',
              baseStyle: TextStyle(),
              selectedStyle: TextStyle()),
          ProfilePage()),
      
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Logout',
            baseStyle: TextStyle(),
            selectedStyle: TextStyle()),
        ElevatedBtn(onTap: () =>{
          AuthService().signOut(context),
        }),
      ),
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
