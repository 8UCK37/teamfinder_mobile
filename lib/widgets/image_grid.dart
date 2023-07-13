import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';
import 'package:shimmer/shimmer.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        children:
            imageUrls.map((url) => _buildCachedNetworkImage(url)).toList(),
      );
    } else if (imageUrls.length == 2) {
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children:
            imageUrls.map((url) => _buildCachedNetworkImage(url)).toList(),
      );
    } else {
      return _advancedGrid(imageUrls);
    }
  }

  Widget _buildCachedNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
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
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/error-404.png'),
      imageBuilder: (context, imageProvider) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
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
