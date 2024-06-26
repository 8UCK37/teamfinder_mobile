import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double BUBBLE_RADIUS_IMAGE = 16;

///basic image bubble type
///
///
/// image bubble should have [id] to work with Hero animations
/// [id] must be a unique value
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display image can be changed using [image]
///[image] is a required parameter
///[id] must be an unique value for each other
///[id] is also a required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state

class ChatImageBubble extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final String imageUrl;
  final String text;
  final String time;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final void Function()? onTap;

  const ChatImageBubble({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.text,
    required this.time,
    this.bubbleRadius = BUBBLE_RADIUS_IMAGE,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
  }) : super(key: key);
  String convertToLocalTime(String time) {
    String timestamp = time;
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    var splicedTime = formattedTime.split(" ")[1].split(":");

    return "${splicedTime[0]}:${splicedTime[1]}";
  }

  bool checkIfLocalImage(String url) {
    return (url.split('/')[2] == 'user');
  }

  /// image bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    // ignore: unused_local_variable
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5,
                maxHeight: MediaQuery.of(context).size.width * .65),
            child: GestureDetector(
                // ignore: sort_child_properties_last
                child: Hero(
                  tag: id,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(bubbleRadius),
                            topRight: Radius.circular(bubbleRadius),
                            bottomLeft: Radius.circular(tail
                                ? (isSender ? bubbleRadius : 0)
                                : BUBBLE_RADIUS_IMAGE),
                            bottomRight: Radius.circular(tail
                                ? (isSender ? 0 : bubbleRadius)
                                : BUBBLE_RADIUS_IMAGE),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(bubbleRadius),
                            child: Column(
                              crossAxisAlignment: isSender
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                ImageTypeSwitcher(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.fill,
                                  height: 200,
                                  width: 200,),
                                Padding(
                                  padding: stateTick
                                      ? const EdgeInsets.only(right: 20)
                                      : const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                  child: Column(
                                    crossAxisAlignment: isSender
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          convertToLocalTime(
                                              time), // Add your subtext here
                                          style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.white,
                                              fontStyle: FontStyle
                                                  .italic), // Specify the style for the subtext
                                          textAlign: isSender
                                              ? TextAlign.end
                                              : TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // stateIcon != null && stateTick
                      //     ? Positioned(
                      //         bottom: 4,
                      //         right: 6,
                      //         child: stateIcon,
                      //       )
                      //     : const SizedBox(
                      //         width: 1,
                      //       ),
                    ],
                  ),
                ),
                onTap: onTap ??
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return _DetailScreen(
                          tag: id,
                          imageWidget: ImageTypeSwitcher(imageUrl: imageUrl,fit: BoxFit.contain,),
                        );
                      }));
                    }),
          ),
        ),
      ],
    );
  }
}

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget imageWidget;

  const _DetailScreen({Key? key, required this.tag, required this.imageWidget})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child:
              Hero(tag: widget.tag, child: Center(child: widget.imageWidget)),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class ImageTypeSwitcher extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  const ImageTypeSwitcher({super.key, 
        required this.imageUrl, 
        this.height, 
        this.width, 
        required this.fit});

  @override
  State<ImageTypeSwitcher> createState() => _ImageTypeSwitcherState();
}

class _ImageTypeSwitcherState extends State<ImageTypeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return widget.imageUrl.startsWith('https')
        ? CachedNetworkImage(
            imageUrl: widget.imageUrl,
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
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: widget.fit,
            height: widget.height,
            width:widget.width
          )
        : Image.file(
            File(widget.imageUrl), 
            fit: widget.fit,
            height: widget.height,
            width:widget.width
          );
  }
}
