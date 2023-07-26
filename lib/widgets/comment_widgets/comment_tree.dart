// ignore_for_file: prefer_const_constructors, prefer_is_empty
import 'package:colorful_progress_indicators/colorful_progress_indicators.dart';
import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class CommentObj extends StatefulWidget {
  final int postId;
  final bool showLines;
  const CommentObj({super.key, required this.postId, required this.showLines});

  @override
  State<CommentObj> createState() => _CommentObjState();
}

class _CommentObjState extends State<CommentObj> with TickerProviderStateMixin {
  late List<CommentPojo> comments = [];
  late List<CommentPojo> commentTree = [];
  bool showLoading = true;
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
      //debugPrint('comments fetched for postId ${widget.postId}');
      if (mounted) {
        setState(() {
          // for (CommentPojo comm in commentPojoFromJson(response.data)) {
          //   debugPrint(comm.commentStr);
          // }
          comments = commentPojoFromJson(response.data);
          commentTree = buildCommentTree(comments);
          //debugPrint('number of parent comment id :${commentTree.length}');
          for (CommentPojo comment in commentTree) {
            //debugPrint('line 136 for comment ${comm.commentStr}: ${comm.reactionMap.toString()}');
            if (comment.children != null && comment.children!.length > 1) {
              for (CommentPojo lvlonecomment in comment.children!) {
                if (lvlonecomment.children != null) {
                  for (CommentPojo lvltwocomment in lvlonecomment.children!) {
                    lvltwocomment.parentHasSiblings = true;
                  }
                }
              }
            }
          }
          showLoading = false;
        });
      }
    }
  }

  List<CommentPojo> buildCommentTree(List<CommentPojo> comments,
      {int? parentCommentId, int level = 0, bool parentHasSiblings = false}) {
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
        parentHasSiblings:
            parentHasSiblings, // Pass the parentHasSiblings value to the child comment.
        children: buildCommentTree(counted,
            parentCommentId: comment.id,
            level: level + 1,
            parentHasSiblings:
                parentHasSiblings), // Check if there are siblings of the current comment.
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
    final userService = Provider.of<ProviderService>(context,listen:false);
    return SafeArea(
        child: Column(
      children: <Widget>[
        if(!showLoading)
          const Divider(thickness: 4,),
        if (showLoading)
          ColorfulLinearProgressIndicator(
            colors: const [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
            duration: Duration(milliseconds: 500),
            initialColor: Colors.red,
          ),
        if(!showLoading && commentTree.length == 0)
          Text('There are currently no comments for this post!!'),
        if (commentTree.length != 0)
          for (CommentPojo parentComment in commentTree)
            commentBox(parentComment, 18, true, true, widget.showLines,userService.darkTheme!),
      ],
    ));
  }

  Widget commentBox(CommentPojo comment, double radius, bool isFirst,
      bool isLast, bool showLine,bool isDark) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  if (showLine)
                    CustomPaint(
                      painter: _ArrowPainter(type: comment.type!),
                    ),
                  if (comment.type != 0 && showLine)
                    CustomPaint(
                      willChange: true,
                      painter: _MainLinePainter(
                          type: comment.type!,
                          comment: comment,
                          isFirst: isFirst,
                          isLast: isLast),
                    ),
                  if (showLine)
                    CustomPaint(
                      willChange: true,
                      painter: _SecondaryLinePainter(
                        type: comment.type!,
                        comment: comment,
                        isFirst: isFirst,
                        isLast: isLast,
                      ),
                    ),
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
                  surfaceTintColor: isDark 
                          ?Color.fromARGB(255, 80, 80, 80)
                          :Colors.grey,
                  color: isDark 
                          ?Color.fromARGB(255, 80, 80, 80)
                          :Color.fromARGB(255, 241, 239, 239),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.author!.name,
                          style: TextStyle(fontSize: 14),
                        ),
                        ExpandableText(
                          comment.commentStr!,
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          linkColor: Colors.blue,
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
                      for (int index = 0;
                          index < comment.children!.length;
                          index++)
                        commentBox(
                            comment.children![index],
                            15,
                            index == 0,
                            index ==
                                comment.children!.length - 1, // isFirst or no
                            showLine,isDark),
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

class _ArrowPainter extends CustomPainter {
  int type = 0;
  _ArrowPainter({required this.type}) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }
  double getLength() {
    switch (type) {
      case 1:
        return -18;
      case 2:
        return -14;
      default:
        return 0;
    }
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();

    path.moveTo(0, 4);
    path.lineTo(getLength(), 4);
    if (type != 0) {
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _MainLinePainter extends CustomPainter {
  int type = 0;
  CommentPojo comment;
  bool isFirst;
  bool isLast;
  _MainLinePainter(
      {required this.type,
      required this.comment,
      required this.isFirst,
      required this.isLast}) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }
  double getLength() {
    switch (type) {
      case 1:
        return -18;
      case 2:
        return -14;
      default:
        return 0;
    }
  }

  double getheight() {
    if (isFirst) {
      switch (type) {
        case 1:
          return -56;
        case 2:
          return -62;
        default:
          return 0;
      }
    } else {
      switch (type) {
        case 1:
          return -77;
        case 2:
          return -76;
        default:
          return 0;
      }
    }
  }

  double getStartingHeight() {
    if (isLast) {
      switch (type) {
        case 1:
          return 4;
        case 2:
          return 4;
        default:
          return 0;
      }
    } else {
      switch (type) {
        case 1:
          return 4;
        case 2:
          return 25;
        default:
          return 0;
      }
    }
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(getLength(), getStartingHeight());
    path.lineTo(getLength(), getheight());
    if (type != 0) {
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _SecondaryLinePainter extends CustomPainter {
  int type = 0;
  CommentPojo comment;
  bool isFirst;
  bool isLast;
  _SecondaryLinePainter({
    required this.type,
    required this.comment,
    required this.isFirst,
    required this.isLast,
  }) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }
  double getLength() {
    switch (type) {
      case 1:
        return -52;
      case 2:
        return -48;
      default:
        return 0;
    }
  }

  double getheight() {
    if (isFirst) {
      switch (type) {
        case 1:
          return -56;
        case 2:
          return -78;
        default:
          return 0;
      }
    } else {
      switch (type) {
        case 1:
          return -76;
        case 2:
          return -78;
        default:
          return 0;
      }
    }
  }

  double getStartingHeight() {
    if (isLast) {
      switch (type) {
        case 1:
          return 4;
        case 2:
          return 6;
        default:
          return 0;
      }
    } else {
      switch (type) {
        case 1:
          return 4;
        case 2:
          return 25;
        default:
          return 0;
      }
    }
  }

  void testComment() {
    debugPrint(
        'for ${comment.commentStr} parent has children: ${comment.parentHasSiblings.toString()}');
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(getLength(), getStartingHeight());
    path.lineTo(getLength(), getheight());
    if (type == 2 && comment.parentHasSiblings!) {
      //testComment();
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
