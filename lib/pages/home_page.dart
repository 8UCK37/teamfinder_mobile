import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/custom_appbar.dart';
import '../services/data_service.dart';
import '../tabs/friends_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/menu_tab.dart';
import '../tabs/notifications_tab.dart';
import '../tabs/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isDark;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);

    // ignore: unused_local_variable
    final userData = userService.user;
    _isDark = userService.darkTheme!;
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          exit(0);
        },
        child: Scaffold(
          appBar: TeamFinderAppBar(
            titleText: "CallOut",
            titleStyle: const TextStyle(
                fontFamily: 'caveat',
                color: Color.fromARGB(255, 200, 66, 72),
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
            isDark: _isDark,
            tabController: _tabController,
            implyLeading: false,
            showNotificationCount: true,
          ),
          body: TabBarView(controller: _tabController, children: [
            HomeTab(tabController: _tabController),
            const ProfileTab(),
            const FriendsTab(),
            const NotificationsTab(),
            MenuTab(_tabController),
          ]),
        ),
      ),
    );
  }
}
