import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';
import 'package:teamfinder_mobile/activity/profile_screen.dart';

import '../reusable_widgets/elevated_buttons.dart';
import '../services/auth_service.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

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
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle()),
          const HomeScreenWidget()),
      
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'ProfilePage',
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle()),
          const ProfilePage()),
      
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Logout',
            baseStyle: const TextStyle(),
            selectedStyle: const TextStyle()),
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
      tittleAppBar: const GNav(
        gap: 0,
        tabs: [
          GButton(
            icon: Icons.home,
            ),
          GButton(
            icon: Icons.badge,
            ),
          GButton(
            icon: Icons.chat,
            ),
          GButton(
            icon: Icons.tune,
            ),
        ] 
      ),
    );
  }
}
