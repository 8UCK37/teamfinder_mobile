import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teamfinder_mobile/widgets/carousel_widget.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return CachedNetworkImage(
        imageUrl: imageUrls[0],
        placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.purpleAccent.shade200,
        highlightColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      );
    } else if (imageUrls.length > 1 && imageUrls.length <= 3) {
      return CustomCarousel(images:imageUrls);
    } else {
      return _advancedGrid(imageUrls);
    }
  }

  Widget _advancedGrid(List<String> imageList) {
    return NewsfeedMultipleImageView(
      imageUrls: imageList,
      marginLeft: 10.0,
      marginRight: 10.0,
      marginBottom: 10.0,
      marginTop: 10.0,
    );
  }

}
