import 'package:flutter/material.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';

import '../misc/image_viewer.dart';

class FeedMultipleImageView extends StatelessWidget {

  final List<String> imageUrls;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;

  const FeedMultipleImageView({
    Key? key,
    this.marginLeft = 0,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, costraints) => Container(
        width: costraints.maxWidth,
        height: costraints.maxWidth,
        margin: EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        child: GestureDetector(
          child: MultipleImageView(imageUrls: imageUrls),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomImageViewer(imageUrls: imageUrls),
            ),
          ),
        ),
      ),
    );
  }
}


