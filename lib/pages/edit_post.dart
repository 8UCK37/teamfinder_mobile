import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_mentions/text/mention_text_editing_controller.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import 'package:teamfinder_mobile/widgets/misc/teamfinder_appbar.dart';
import 'package:teamfinder_mobile/widgets/simplyMention/simply_mention_interface.dart';

class EditPost extends StatefulWidget {
  final PostPojo post;
  const EditPost({super.key, required this.post});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  GlobalKey mentionKey = GlobalKey();
  FocusNode focusNode = FocusNode();
  List<MentionObject> mentionObjectList = [];

  @override
  void initState() {
    super.initState();
    convertIntoMarkUp();
  }

  String convertIntoMarkUp() {
    if (widget.post.description == null) {
      return '';
    }
    String desc = widget.post.description!;
    //debugPrint(desc);
    for (var item in widget.post.mention!.list) {
      String id = item['id'];
      RegExp regex = RegExp(r'\b' + RegExp.escape(id) + r'\b');

      String replaceMent = "<###@$id###>";
      desc = desc.replaceAll(regex, replaceMent);
    }
    return desc;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    
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
        child: Column(
          children: [
            SimplyMentionInterface(
              key: mentionKey,
              focusNode: focusNode,
              markUptext: convertIntoMarkUp(),
              mentionableList: notiObserver.mentionAbleList,
            ),
          ],
        ),
      ),
    );
  }
}
