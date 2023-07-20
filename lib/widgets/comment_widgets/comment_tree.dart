// ignore_for_file: prefer_const_constructors, prefer_is_empty
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/pojos/comment_pojo.dart';
import 'package:teamfinder_mobile/widgets/separator_widget.dart';

class CommentObj extends StatefulWidget {
  final List<CommentPojo> tree;
  const CommentObj({super.key, required this.tree});

  @override
  State<CommentObj> createState() => _CommentObjState();
}

class _CommentObjState extends State<CommentObj> {
  @override
  Widget build(BuildContext context) {
    List<Widget> render = [];
    for (CommentPojo parentComment in widget.tree) {
      int depth = 0;
      depth = depth + 1;
      render.add(commentBox(parentComment, 18,));
      render.add(Divider(thickness: 2,));
    }
    return SafeArea(
        child: Column(
      children: render,
    ));
  }

  Widget commentBox(CommentPojo comment, double radius,) {
    return SafeArea(
      child: SizedBox(
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
                                  comment.showChildren =!(comment.showChildren!);
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
                          commentBox(child,15,),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


