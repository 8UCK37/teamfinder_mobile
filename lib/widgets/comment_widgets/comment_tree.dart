// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';

class CommentObj extends StatelessWidget {
  final List<CommentPojo> tree;
  const CommentObj({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    List<Widget> render = [];
    for (CommentPojo parentComment in tree) {
      render.add(commentBox(parentComment, 18));
      if (parentComment.children != null) {
        for (CommentPojo child in parentComment.children!) {
          render.add(Padding(
            padding: const EdgeInsets.only(left: 15),
            child: commentBox(child, 15),
          ));
          if (child.children != null) {
            for (CommentPojo grandKid in child.children!) {
              render.add(Padding(
                padding: const EdgeInsets.only(left: 30),
                child: commentBox(grandKid, 15),
              ));
            }
          }
        }
      }
      render.add(Divider(
        thickness: 4,
      ));
    }
    return SafeArea(
        child: Column(
      children: render,
    ));
  }

  Widget commentBox(CommentPojo comment, double radius) {
    return SafeArea(
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                    child: const Row(
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
