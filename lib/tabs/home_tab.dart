import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../pojos/post_pojo.dart';
import '../widgets/online_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/separator_widget.dart';
import '../widgets/write_something_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin<HomeTab> {
  List<PostPojo>? postList;


  @override
  bool get wantKeepAlive => true;


  Future<void> _handleRefresh() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userService = Provider.of<ProviderService>(context, listen: true);
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
