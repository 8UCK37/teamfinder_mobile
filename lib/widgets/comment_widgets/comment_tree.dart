import 'package:comment_tree/data/comment.dart';
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';
import 'package:teamfinder_mobile/widgets/comment_widgets/custom_comment_tree_widget.dart';
import 'package:teamfinder_mobile/widgets/comment_widgets/custom_treeTheme.dart';

class CommentObj extends StatelessWidget {
  final CommentPojo parentComment;
  const CommentObj({super.key, required this.parentComment});

  @override
  Widget build(BuildContext context) {
    return CommentTreeWidget<Comment, Comment>(
      Comment(
          avatar: 'null',
          userName: 'null',
          content: 'felangel made felangel/cubit_and_beyond public '),
      [
        Comment(
            avatar: 'null',
            userName: 'null',
            content: 'A Dart template generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content:
                'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content: 'A Dart template generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content:
                'A Dart template generator which helps teams generator which helps teams '),
      ],
      treeThemeData:const TreeThemeData(
          lineColor:  Color.fromARGB(255, 80, 64, 147), lineWidth: 3),
      avatarRoot: (context, data) => const PreferredSize(
        preferredSize: Size.fromRadius(18),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/avatar_2.png'),
        ),
      ),
      avatarChild: (context, data) => const PreferredSize(
        preferredSize: Size.fromRadius(12),
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/avatar_1.png'),
        ),
      ),
      contentChild: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'dangngocduc',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${data.content}',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'dangngocduc',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${data.content}',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
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
    );
  }
}
