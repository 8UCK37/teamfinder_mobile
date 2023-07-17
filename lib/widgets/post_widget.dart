// ignore_for_file: sort_child_properties_last

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profile_home.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/widgets/image_grid.dart';

class PostWidget extends StatefulWidget {
  final PostPojo post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with SingleTickerProviderStateMixin {

  String convertToLocalTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
  }

  @override
  void initState() {
    super.initState();
    //debugPrint(widget.post.description.toString());
    if (widget.post.mention != null) {
      //debugPrint(widget.post.parentpost!.mention!.list.toString());
      parseDescription(
          widget.post.description.toString(), widget.post.mention!);
    }
    if (widget.post.parentpost?.mention != null) {
      //debugPrint(widget.post.parentpost!.mention!.list.toString());
      parseDescription(widget.post.parentpost!.description.toString(),
          widget.post.parentpost!.mention!);
    }
  }

  String parseDescription(String desc, Mention mentionList) {
    String sanitizedDesc = desc.substring(0, desc.length - 1);
    Map<String, String> idNameMap = {
      for (var item in mentionList.list) item['id']: item['name']
    };
    late String dump = '';
    for (String key in idNameMap.keys) {
      dump = sanitizedDesc.replaceAll(key, idNameMap[key].toString());
    }
    return (dump);
  }

  Widget parseDescriptionWidget(String desc, Mention mentionList) {
    String sanitizedDesc = desc.substring(0, desc.length - 1);
    Map<String, String> idNameMap = {
      for (var item in mentionList.list) item['id']: item['name']
    };
    DateTime now = DateTime.now();
    List<TextSpan> textSpans = [];

    for (String word in sanitizedDesc.split(' ')) {
      if (idNameMap.containsKey(word)) {
        textSpans.add(
          TextSpan(
              text: '${idNameMap[word]} ',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint('${now.toString()} yooooo:${word}');
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => FriendProfilePage(
                            friendId: word,
                          ));
                  Navigator.of(context)
                      .push(route); // Prints the corresponding ID
                },
              style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  fontSize: 18)),
        );
      } else {
        textSpans.add(TextSpan(text: '$word '));
      }
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style:
            DefaultTextStyle.of(context).style, // Apply the default text style
      ),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return Material(
        child: ListView(
          controller: scrollController,
        ),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.post.profilePicture!),
                radius: 20.0,
              ),
              const SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.post.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  const SizedBox(height: 5.0),
                  Text(convertToLocalTime(widget.post.createdAt))
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                widget.post.mention?.list.length != 0
                    ? parseDescription(
                        widget.post.description!, widget.post.mention!)
                    : widget.post.description!,
                style: const TextStyle(fontSize: 15.0)),
          ),
          if (widget.post.shared != null)
            Container(
              //color: const Color.fromARGB(110, 222, 221, 221),
              decoration: const BoxDecoration(
                color: Color.fromARGB(110, 222, 221,
                    221), // Set the desired background color here
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              widget.post.parentpostauthor.profilePicture!),
                          radius: 20.0,
                        ),
                        const SizedBox(width: 7.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.post.parentpostauthor.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                            const SizedBox(height: 5.0),
                            Text(convertToLocalTime(
                                widget.post.parentpost!.createdAt))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: parseDescriptionWidget(
                          widget.post.parentpost!.description!,
                          widget.post.parentpost!.mention!),
                    ),
                  ),
                ],
              ),
            ),
          //const SizedBox(height: 5.0),
          ImageGrid(
              imageUrls: (widget.post.shared == null)
                  ? widget.post.photoUrl!.split(',')
                  : widget.post.parentpost!.photoUrl!.split(',')),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(FontAwesomeIcons.thumbsUp,
                      size: 15.0, color: Colors.blue),
                  Text(' ${widget.post.likecount}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                      '${widget.post.hahacount} comments  •  '), //TODO:need to assign real values
                  Text('${widget.post.lovecount} shares'),
                ],
              ),
            ],
          ),

          const Divider(height: 30.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.thumbsUp, size: 20.0),
                  SizedBox(width: 5.0),
                  Text('Like', style: TextStyle(fontSize: 14.0)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  //debugPrint('open bottom sheet');
                  showStickyFlexibleBottomSheet(
                    decoration:const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    ),
                    minHeight: 0,
                    initHeight: 1,
                    maxHeight: 1,
                    headerHeight: 25,
                    context: context,
                    bottomSheetColor: Colors.white,
                    headerBuilder: (BuildContext context, double offset) {
                      return Container(
                      );
                    },
                    bodyBuilder: (BuildContext context, double offset) {
                      return SliverChildListDelegate(
                        <Widget>[
                          Container(
                            child: Column(
                              children: [
                                CommentTreeWidget<Comment, Comment>(
                                  Comment(
                                      avatar: 'null',
                                      userName: 'null',
                                      content:
                                          'felangel made felangel/cubit_and_beyond public '),
                                  [
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams generator which helps teams '),
                                  ],
                                  
                                  treeThemeData: TreeThemeData(
                                      lineColor: Colors.green[500]!, lineWidth: 3),
                                  avatarRoot: (context, data) => const PreferredSize(
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/avatar_2.png'),
                                    ),
                                    preferredSize: Size.fromRadius(18),
                                  ),
                                  avatarChild: (context, data) => const PreferredSize(
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/avatar_1.png'),
                                    ),
                                    preferredSize: Size.fromRadius(12),
                                  ),
                                  contentChild: (context, data) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'dangngocduc',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${data.content}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                        fontWeight: FontWeight.w300,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text('Like'),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Text('Reply'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  contentRoot: (context, data) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'dangngocduc',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${data.content}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w300,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text('Like'),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Text('Reply'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                CommentTreeWidget<Comment, Comment>(
                                  Comment(
                                      avatar: 'null',
                                      userName: 'null',
                                      content:
                                          'felangel made felangel/cubit_and_beyond public '),
                                  [
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams'),
                                    Comment(
                                        avatar: 'null',
                                        userName: 'null',
                                        content:
                                            'A Dart template generator which helps teams generator which helps teams '),
                                  ],
                                  
                                  treeThemeData: TreeThemeData(
                                      lineColor: Colors.green[500]!, lineWidth: 3),
                                  avatarRoot: (context, data) => const PreferredSize(
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/avatar_2.png'),
                                    ),
                                    preferredSize: Size.fromRadius(18),
                                  ),
                                  avatarChild: (context, data) => const PreferredSize(
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/avatar_1.png'),
                                    ),
                                    preferredSize: Size.fromRadius(12),
                                  ),
                                  contentChild: (context, data) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'dangngocduc',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${data.content}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                        fontWeight: FontWeight.w300,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text('Like'),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Text('Reply'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  contentRoot: (context, data) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'dangngocduc',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${data.content}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w300,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text('Like'),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Text('Reply'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ],
                      );
                    },
                    anchors: [0, 0.5, 1],
                  );
                },
                child: const Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                    SizedBox(width: 5.0),
                    Text('Comment', style: TextStyle(fontSize: 14.0)),
                  ],
                ),
              ),
              const Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.share, size: 20.0),
                  SizedBox(width: 5.0),
                  Text('Share', style: TextStyle(fontSize: 14.0)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
