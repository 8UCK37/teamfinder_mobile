import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/widgets/misc/imageSlideshow.dart';

class CustomImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  const CustomImageViewer({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer> {
  bool disableUserScrolling = false;
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
                  disableUserScrolling: disableUserScrolling,
                  indicatorBackgroundColor: Colors.grey,
                  isLoop: widget.imageUrls.length > 1,
                  children: widget.imageUrls
                      .map(
                        (e) => InteractiveViewer(
                          onInteractionStart: (details) {
                            setState(() {
                              disableUserScrolling = true;
                            });
                          },
                          onInteractionEnd: (details) {
                            setState(() {
                              disableUserScrolling = false;
                            });
                          },
                          child: CachedNetworkImage(
                            fadeInDuration: const Duration(milliseconds: 50),
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
                          ),
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
