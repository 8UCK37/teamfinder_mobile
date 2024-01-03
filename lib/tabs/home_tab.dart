import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../pojos/post_pojo.dart';
import '../widgets/misc/online_widget.dart';
import '../widgets/post_widgets/post_widget.dart';
import '../widgets/misc/separator_widget.dart';
import '../widgets/misc/write_something_widget.dart';

class HomeTab extends StatefulWidget {
  final TabController tabController;
  const HomeTab({super.key, required this.tabController,});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {

  @override
  bool get wantKeepAlive => true;

  Future<void> _handleRefresh() async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.reloadUser(context);
    userService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userService = Provider.of<ProviderService>(context, listen: true);
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Divider(
                color: userService.darkTheme!
                    ? const Color.fromARGB(255, 74, 74, 74)
                    : Colors.grey),
            const OnlineWidget(),
            SeparatorWidget(
                color: userService.darkTheme!
                    ? const Color.fromARGB(255, 74, 74, 74)
                    : Colors.grey),
            const WriteSomethingWidget(),
            if (userService.feed != null) // Add a null check here
              for (PostPojo post in userService.feed!) // Add a null check here
                Column(
                  children: <Widget>[
                    SeparatorWidget(
                        color: userService.darkTheme!
                            ? const Color.fromARGB(255, 74, 74, 74)
                            : Colors.grey),
                    PostWidget(post: post,tabController: widget.tabController,),
                  ],
                ),
            SeparatorWidget(
                color: userService.darkTheme!
                    ? const Color.fromARGB(255, 74, 74, 74)
                    : Colors.grey),
          ],
        ),
      ),
    );
  }
}
