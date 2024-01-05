import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/widgets/misc/teamfinder_appbar.dart';

class EditPost extends StatefulWidget {
  final PostPojo post;
  const EditPost({super.key, required this.post});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Scaffold(
      appBar: TeamFinderAppBar(
          titleText: "Edit Post",
          isDark: userService.darkTheme!,
          implyLeading: true,
          height: 55,
          showNotificationCount: false,
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      ),
    );
  }
}
