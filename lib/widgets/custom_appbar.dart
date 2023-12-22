import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../chat_ui/chat_home.dart';
import '../pages/search_page.dart';

class TeamFinderAppBar extends StatefulWidget implements PreferredSizeWidget{
  final bool isDark;
  final TabController tabController;
  const TeamFinderAppBar({super.key, required this.isDark, required this.tabController});

  @override
  State<TeamFinderAppBar> createState() => _TeamFinderAppBarState();
  
   @override
  Size get preferredSize => const Size.fromHeight(105);
}

class _TeamFinderAppBarState extends State<TeamFinderAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  widget.isDark ? Brightness.light : Brightness.dark),
          backgroundColor:
              widget.isDark ? const Color.fromRGBO(46, 46, 46, 1) : Colors.white,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('TeamFinder',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          debugPrint('search clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
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
                              backgroundColor:
                                  Color.fromRGBO(222, 209, 242, 100),
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
                            child: Icon(Icons.question_answer,
                                color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ]),
              ]),
          elevation: 0.0,
          bottom: TabBar(
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
          ),
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
        );
  }
}