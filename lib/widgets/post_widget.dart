// ignore_for_file: sort_child_properties_last

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profile_home.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/widgets/comment_tree.dart';
import 'package:teamfinder_mobile/widgets/image_grid.dart';
import 'package:teamfinder_mobile/widgets/separator_widget.dart';

class PostWidget extends StatefulWidget {
  final PostPojo post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  late List<CommentPojo> comments;
  late List<CommentPojo> commentTree;
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
    debugPrint(widget.post.id.toString());
    fetchComments();
  }

  String convertToLocalTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
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

  void fetchComments() async {
    debugPrint(widget.post.id.toString());
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();

    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/comment?id=${widget.post.id}',
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('comments fetched for postId ${widget.post.id}');
      setState(() {
        // for (CommentPojo comm in commentPojoFromJson(response.data)) {
        //   debugPrint(comm.commentStr);
        // }
        comments = commentPojoFromJson(response.data);
        commentTree = buildCommentTree(comments);
        debugPrint('number of parent comment id :${commentTree.length}');
        for (CommentPojo comm in commentTree) {
          debugPrint(
              'line 136 for comment ${comm.commentStr}: ${comm.reactionMap.toString()}');
        }
      });
    }
  }

  List<CommentPojo> buildCommentTree(List<CommentPojo> comments,
      {int? parentCommentId}) {
    List<CommentPojo> counted = [];
    for (var comment in comments) {
      counted.add(countReaction(comment));
    }
    List<CommentPojo> childComments = counted
        .where((comment) => comment.commentOf == parentCommentId)
        .map((comment) {
      return CommentPojo(
        id: comment.id,
        createdAt: comment.createdAt,
        commentStr: comment.commentStr,
        commentOf: comment.commentOf,
        postsId: comment.postsId,
        userId: comment.userId,
        deleted: comment.deleted,
        author: comment.author,
        userReaction: comment.userReaction,
        reactionMap: comment.reactionMap,
        commentReaction: comment.commentReaction,
        children: buildCommentTree(counted, parentCommentId: comment.id),
      );
    }).toList();
    return childComments.isNotEmpty ? childComments : [];
  }

  CommentPojo countReaction(CommentPojo comment) {
    Map<String, int> reactionMap = {};
    reactionMap['total'] = 0;
    comment.userReaction = null;
    final user = FirebaseAuth.instance.currentUser;
    List<dynamic> commentReactions = comment.commentReaction!;
    for (var reaction in commentReactions) {
      if (reaction['author']['id'] == user!.uid) {
        comment.userReaction = reaction;
        //debugPrint('from line 183: ${comment.userReaction.toString()}');
      }

      if (reaction['type'] != 'dislike') {
        if (reactionMap.containsKey(reaction['type'])) {
          reactionMap[reaction['type']] = reactionMap[reaction['type']]! + 1;
        } else {
          reactionMap[reaction['type']] = 1;
        }
        reactionMap['total'] = reactionMap['total']! + 1;
      }
    }
    comment.reactionMap = reactionMap;
    return comment;
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
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                    minHeight: 0,
                    initHeight: 1,
                    maxHeight: 1,
                    headerHeight: 75,
                    context: context,
                    bottomSheetColor: Colors.white,
                    headerBuilder: (BuildContext context, double offset) {
                      return AppBar(
                          automaticallyImplyLeading: false,
                          title: const Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                              Row(
                                children: [Text('Comments')],
                              ),
                            ],
                          ));
                    },
                    bodyBuilder: (BuildContext context, double offset) {
                      return SliverChildListDelegate(
                        <Widget>[
                          Container(
                            child: Column(
                              children: [
                                // ignore: unnecessary_null_comparison
                                if (commentTree != null) 
                                  for(CommentPojo parentComment in commentTree)
                                    Column(
                                      children: <Widget>[
                                        const Divider(thickness: 4,),
                                        CommentObj(parentComment: parentComment,),
                                      ],
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
