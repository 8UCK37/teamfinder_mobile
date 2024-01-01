import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';
import 'package:teamfinder_mobile/widgets/misc/carousel_widget.dart';
import 'package:teamfinder_mobile/widgets/misc/imageSlideshow.dart';


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
              builder: (context) => ImageViewer(imageUrls: imageUrls),
            ),
          );
        },
        child: Visibility(
          visible: imageUrls[0]!="",
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
              builder: (context) => ImageViewer(imageUrls: imageUrls),
            ),
          );
        },
        child: CustomCarousel(images: imageUrls)
        );
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

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  const ImageViewer({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Expanded(
                child: ImageSlideshow(
                  initialPage: 0,
                  indicatorColor: Colors.red,
                  indicatorBackgroundColor: Colors.grey,
                  isLoop: imageUrls.length > 1,
                  children: imageUrls.map((e) => ClipRect(
                    child: CachedNetworkImage(
                          imageUrl: e,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: ColorfulCircularProgressIndicator(
                                colors: [
                                  Colors.blue,
                                  Colors.red,
                                  Colors.amber,
                                  Colors.green
                                ],
                                strokeWidth: 5,
                                indicatorHeight: 5,
                                indicatorWidth: 5,
                              ),
                            ),
                          ),
                        )
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
