import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../chat_ui/chat_home.dart';
import '../pages/search_page.dart';
import '../services/notification_observer.dart';

class TeamFinderAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final TabController? tabController;
  final String titleText;
  final bool implyLeading;
  final double? height;
  final bool showNotificationCount;
  final TextStyle? titleStyle;
  const TeamFinderAppBar(
      {super.key,
      required this.isDark,
      this.tabController,
      required this.titleText,
      required this.implyLeading,
      this.height,
      required this.showNotificationCount, 
      this.titleStyle});

  @override
  State<TeamFinderAppBar> createState() => _TeamFinderAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height != null ? height! : 105);
}

class _TeamFinderAppBarState extends State<TeamFinderAppBar> {
  @override
  Widget build(BuildContext context) {
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    return AppBar(
      automaticallyImplyLeading: widget.implyLeading,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              widget.isDark ? Brightness.light : Brightness.dark),
      backgroundColor:
          widget.isDark ? const Color.fromRGBO(46, 46, 46, 1) : Colors.white,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.titleText,
                style:  widget.titleStyle?? const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              if (widget.showNotificationCount &&
                  notiObserver.incomingNotificationList.isNotEmpty)
                Container(
                  height: 25,
                  width: 25,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Center(
                    child: Text(
                      notiObserver.incomingNotificationList.length
                          .toString(), // Your superscript text
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  debugPrint('search clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                      child: Icon(Icons.search, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('goto chat');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatHome()),
                  );
                },
                child: const Material(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                    child:
                        Icon(Icons.question_answer, color: Colors.deepPurple),
                  ),
                ),
              ),
            ]),
          ]),
      elevation: 0.0,
      bottom: (widget.tabController != null)
          ? TabBar(
              key: const Key('tabBar'),
              indicatorColor: Colors.deepPurple,
              controller: widget.tabController,
              unselectedLabelColor: Colors.grey,
              //labelColor: Colors.deepPurple,
              tabs: const [
                Tab(
                    icon: Icon(
                  Icons.receipt_long,
                  size: 28.0,
                  color: Colors.blue,
                )),
                Tab(
                    icon: Icon(
                  Icons.co_present,
                  size: 28.0,
                  color: Colors.green,
                )),
                Tab(
                    icon: Icon(Icons.diversity_3,
                        size: 32.0, color: Colors.purple)),
                Tab(
                    icon: Icon(
                  FontAwesomeIcons.bell,
                  size: 25.0,
                  color: Colors.red,
                )),
                Tab(
                    icon: Icon(Icons.menu,
                        size: 30.0, color: Colors.orange, key: Key('menuTab')))
              ],
            )
          : null,
      //systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
