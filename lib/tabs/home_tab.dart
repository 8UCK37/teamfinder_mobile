
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../widgets/online_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/separator_widget.dart';
import '../widgets/stories_widget.dart';
import '../widgets/write_something_widget.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          WriteSomethingWidget(),
          SeparatorWidget(),
          OnlineWidget(),
          //SeparatorWidget(),
          //StoriesWidget(),
          for(Post post in posts) Column(
            children: <Widget>[
              SeparatorWidget(),
              PostWidget(post: post),
            ],
          ),
          SeparatorWidget(),
        ],
      ),
    );
  }
}