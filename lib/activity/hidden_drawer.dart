import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';
import '../reusable_widgets/elevated_buttons.dart';
import '../services/auth_service.dart';
import 'own_profile_screen.dart';

class HiddenDrawer extends StatefulWidget {
  final int initPositionSelected;
  const HiddenDrawer({Key? key, this.initPositionSelected = 0}) : super(key: key);

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
              selectedStyle: const TextStyle(),
              colorLineSelected: Colors.deepPurple
              ),
          const HomeScreenWidget()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'ProfilePage',
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle(),
              colorLineSelected: Colors.deepPurple),
          const ProfilePage()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Logout',
            baseStyle: const TextStyle(),
            selectedStyle: const TextStyle(),
            colorLineSelected: Colors.deepPurple),
        ElevatedBtn(
            onTap: () => {
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
      slidePercent: 40,
      initPositionSelected: widget.initPositionSelected,
      tittleAppBar: GNav(gap: 0, tabs: [
        GButton(
          icon: Icons.home,
          onPressed: () {
            Navigator.push(context,
            // ignore: prefer_const_constructors
              MaterialPageRoute(builder: (context) => HiddenDrawer(initPositionSelected: 0)),
          );
          },
        ),
        GButton(
          icon: Icons.chat,
          
        ),
        GButton(
          icon: Icons.badge,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HiddenDrawer(initPositionSelected: 1)),
            );
          },
        ),
        GButton(
          icon: Icons.tune,
        ),
      ]),
    );
  }
}
