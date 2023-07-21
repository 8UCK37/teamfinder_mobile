// ignore_for_file: prefer_const_constructors, prefer_is_empty
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';

class CommentObj extends StatefulWidget {
  final int postId;

  const CommentObj({super.key, required this.postId});

  @override
  State<CommentObj> createState() => _CommentObjState();
}

class _CommentObjState extends State<CommentObj> with TickerProviderStateMixin {
  late List<CommentPojo> comments=[];
  late List<CommentPojo> commentTree=[];
  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  void fetchComments() async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();

    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/comment?id=${widget.postId}',
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('comments fetched for postId ${widget.postId}');
      if (mounted) {
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
  }

  List<CommentPojo> buildCommentTree(List<CommentPojo> comments,
      {int? parentCommentId, int level = 0}) {
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
        showChildren: false,
        type: level, // Set the type/level of the current comment.
        children: buildCommentTree(counted,
            parentCommentId: comment.id, level: level + 1),
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
    return SafeArea(
        child: Column(
      children: <Widget>[
        if(commentTree.length!=0)
        for (CommentPojo parentComment in commentTree)
          commentBox(
            parentComment,
            18,
          ),
      ],
    ));
  }

  Widget commentBox(
    CommentPojo comment,
    double radius,
  ) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundImage:
                          NetworkImage(comment.author!.profilePicture),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  surfaceTintColor: Colors.grey,
                  color: Color.fromARGB(255, 241, 239, 239),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.author!.name,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          comment.commentStr!,
                          style: TextStyle(fontSize: 13),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Like',
                        style: TextStyle(fontSize: 13),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Reply',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      if (comment.children!.length != 0)
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: InkWell(
                            child: Text(
                              (comment.showChildren!) ? 'Less...' : 'More...',
                              style: TextStyle(fontSize: 13),
                            ),
                            onTap: () {
                              // Handle the tap to show the children comments here
                              // You can use a state variable to control the visibility of children
                              setState(() {
                                comment.showChildren = !(comment.showChildren!);
                              });
                            },
                          ),
                        )
                    ],
                  ),
                ),
                if (comment.showChildren! && comment.children != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (CommentPojo child in comment.children!)
                        commentBox(
                          child,
                          15,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
