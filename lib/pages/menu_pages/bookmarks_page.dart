import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../pojos/post_pojo.dart';
import '../../services/data_service.dart';
import '../../widgets/misc/teamfinder_appbar.dart';
import '../../widgets/misc/separator_widget.dart';
import '../../widgets/post/post_widget.dart';

class BookMarkedPosts extends StatefulWidget {
  const BookMarkedPosts({super.key});

  @override
  State<BookMarkedPosts> createState() => _BookMarkedPostsState();
}

class _BookMarkedPostsState extends State<BookMarkedPosts> {
  final bookmarkBox = Hive.box('bookmarkBox1');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: TeamFinderAppBar(
          titleText: "Bookmarks",
          isDark: userService.darkTheme!,
          implyLeading: true,
          height: 55,
          showNotificationCount: false,
        ),
        body: Scaffold(
          appBar: AppBar(
            toolbarHeight: 55,
            title: Center(
              child: Card(
                elevation: 10,
                child: Container(
                  height: 45,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.pinkAccent, Color.fromARGB(255, 18, 206, 206)]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            children: [
                          const TextSpan(text: "You have "),
                          TextSpan(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              text: "${userService.bookMarkedPosts.length} "),
                          TextSpan(
                              text: userService.bookMarkedPosts.length > 1
                                  ? " bookmarked posts"
                                  : " bookmarked post")
                        ])),
                  ),
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.orange,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                for (PostPojo post
                    in userService.bookMarkedPosts) // Add a null check here
                  Column(
                    children: <Widget>[
                      SeparatorWidget(
                          color: userService.darkTheme!
                              ? const Color.fromARGB(255, 74, 74, 74)
                              : Colors.grey),
                      PostWidget(
                        post: post,
                      ),
                    ],
                  ),
                SeparatorWidget(
                    color: userService.darkTheme!
                        ? const Color.fromARGB(255, 74, 74, 74)
                        : Colors.grey)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
