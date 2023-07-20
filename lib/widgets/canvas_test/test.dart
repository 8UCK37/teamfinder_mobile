import 'package:comment_tree/data/comment.dart';
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/widgets/canvas_test/custom_comment_tree.dart';
import 'package:teamfinder_mobile/widgets/canvas_test/custom_theme.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: CustomCommentTreeWidget<Comment, Comment>(
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
            treeThemeData: TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 3),
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
          ),
        ),
      ),
    );
  }
}

   
  