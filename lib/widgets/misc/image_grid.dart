import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teamfinder_mobile/widgets/misc/carousel_widget.dart';
import 'package:teamfinder_mobile/widgets/misc/image_viewer.dart';

import '../post/image_collage.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomImageViewer(imageUrls: imageUrls),
            ),
          );
        },
        child: Visibility(
          visible: imageUrls[0] != "",
          child: CachedNetworkImage(
            imageUrl: imageUrls[0],
            placeholder: (context, url) => const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: ColorfulCircularProgressIndicator(
                  colors: [Colors.blue, Colors.red, Colors.amber, Colors.green],
                  strokeWidth: 5,
                  indicatorHeight: 5,
                  indicatorWidth: 5,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (imageUrls.length > 1 && imageUrls.length <= 3) {
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomImageViewer(imageUrls: imageUrls),
              ),
            );
          },
          child: CustomCarousel(images: imageUrls));
    } else {
      return _advancedGrid(imageUrls);
    }
  }

  Widget _advancedGrid(List<String> imageList) {
    return FeedMultipleImageView(
      imageUrls: imageList,
      marginLeft: 10.0,
      marginRight: 10.0,
      marginBottom: 10.0,
      marginTop: 10.0,
    );
  }
}

