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
      int depth = 0;
      depth = depth + 1;
      render.add(commentBox(parentComment, 18,
          (parentComment.children!.length == 0), true, depth));
      if (parentComment.children != null) {
        for (CommentPojo child in parentComment.children!) {
          depth = depth + 1;
          render.add(Padding(
            padding: const EdgeInsets.only(left: 25),
            child: commentBox(
                child, 15, (child.children!.length == 0), false, depth),
          ));
          if (child.children != null) {
            for (CommentPojo grandKid in child.children!) {
              depth = depth + 1;
              render.add(Padding(
                padding: const EdgeInsets.only(left: 47),
                child: commentBox(grandKid, 15,
                    (grandKid.children!.length == 0), false, depth),
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

  Widget commentBox(CommentPojo comment, double radius, bool isLast,
      bool isFirst, int index) {
    return SafeArea(
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    if (!isFirst)
                      CustomPaint(
                        painter: ArrowPainter(),
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
                if (!isLast)
                  CustomPaint(
                    painter: LinePainter(comment),
                  ),
                if (isLast && !isFirst)
                  CustomPaint(
                    painter: UpwardLinePainter(index.toDouble()),
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

class LinePainter extends CustomPainter {
  final CommentPojo comment;
  LinePainter(this.comment);

  double countOffspring(CommentPojo comment) {
    int count = comment.children?.length ?? 0;
    if (comment.children!.length == 1) {
      return 1;
    }
    if (comment.children != null) {
      for (CommentPojo child in comment.children!) {
        count += countOffspring(child).toInt();
      }
    }
    return count.toDouble();
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0); // Starting point
    path.lineTo(0, 63 * countOffspring(comment)); // First vertical line
    //path.lineTo(14, 55); // Bottom horizontal line

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 5); // Starting point
    path.lineTo(-8, 5); // horizontal line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class UpwardLinePainter extends CustomPainter {
  final double multiplier;
  UpwardLinePainter(this.multiplier);
  double formatMultiplier() {
    debugPrint(this.multiplier.toString());
    if (this.multiplier == 1) {
      return this.multiplier * 0.5;
    } else {
      return this.multiplier;
    }
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(-22, -15); // Starting point
    path.lineTo(-22, -22.5 * formatMultiplier()); // vertical line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
