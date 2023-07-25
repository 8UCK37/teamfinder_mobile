import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/user_service.dart';
import '../pojos/post_pojo.dart';
import '../widgets/online_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/separator_widget.dart';
import '../widgets/write_something_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  List<PostPojo>? postList;
  @override
  void initState() {
    super.initState();
  }

  

  Future<void> _handleRefresh() async {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    postList = userService.feed;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Divider(),
            const OnlineWidget(),
            const SeparatorWidget(),
            const WriteSomethingWidget(),
            if (postList != null) // Add a null check here
              for (PostPojo post in postList!) // Add a null check here
                Column(
                  children: <Widget>[
                    const SeparatorWidget(),
                    PostWidget(post: post),
                  ],
                ),
            const SeparatorWidget(),
          ],
        ),
      ),
    );
  }
}
