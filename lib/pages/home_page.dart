import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/custom_appbar.dart';
import '../services/data_service.dart';
import '../services/socket_service.dart';
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
    socketInit();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void socketInit() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final SocketService socketService = SocketService();
        socketService.setupSocketConnection(context);
        socketService.setSocketId(userService.user['id']);
        userService.setSocket(socketService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    // ignore: unused_local_variable
    final userData = userService.user;
    _isDark = userService.darkTheme!;
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: TeamFinderAppBar(
          titleText: "TeamFinder",
          isDark: _isDark,
          tabController: _tabController,
          implyLeading: false,
          showNotificationCount: true,
        ),
        body: TabBarView(controller: _tabController, children: [
          const HomeTab(),
          const ProfileTab(),
          const FriendsTab(),
          const NotificationsTab(),
          MenuTab(_tabController),
        ]),
      ),
    );
  }
}
