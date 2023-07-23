// ignore_for_file: sort_child_properties_last
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profile_home.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/widgets/comment_widgets/comment_tree.dart';
import 'package:teamfinder_mobile/widgets/image_grid.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/custom_animated_reaction.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';

class PostWidget extends StatefulWidget {
  final PostPojo post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String convertToLocalTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
  }

  String parseDescription(String desc, Mention mentionList) {
    String sanitizedDesc = desc.substring(0, desc.length - 1);
    Map<String, String> idNameMap = {
      for (var item in mentionList.list) item['id']: item['name']
    };
    late String dump = '';
    for (String key in idNameMap.keys) {
      dump = sanitizedDesc.replaceAll(key, idNameMap[key].toString());
    }
    return (dump);
  }

  Widget UserReaction() {
    if (widget.post.noreaction!) {
      return SizedBox(
        height: 45,
        width: 45,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Colors.grey,
                Colors.grey
              ], // You can change the colors if needed.
              stops: [0.0, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          blendMode: BlendMode
              .srcATop, // This preserves the transparency of the image.
          child: const Image(
            image: AssetImage("assets/images/fire.gif"),
            width: 45,
            height: 45,
          ),
        ),
      );
    } else {
      String path(String s) {
        switch (s) {
          case "like":
            return "assets/images/fire.gif";
          case "haha":
            return "assets/images/haha.gif";
          case "sad":
            return "assets/images/sad.gif";
          case "love":
            return "assets/images/love.gif";
          case "poop":
            return "assets/images/poop.gif";
          default:
            return "null";
        }
      }

      return SizedBox(
        height: 45,
        width: 45,
        child: Image(
          image: AssetImage(path(widget.post.reactiontype)),
          width: 45,
          height: 45,
        ),
      );
    }
  }

  Widget parseDescriptionWidget(String desc, Mention mentionList) {
    String sanitizedDesc = desc.substring(0, desc.length - 1);
    Map<String, String> idNameMap = {
      for (var item in mentionList.list) item['id']: item['name']
    };
    //DateTime now = DateTime.now();
    List<TextSpan> textSpans = [];

    for (String word in sanitizedDesc.split(' ')) {
      if (idNameMap.containsKey(word)) {
        textSpans.add(
          TextSpan(
              text: '${idNameMap[word]} ',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => FriendProfilePage(
                            friendId: word,
                          ));
                  Navigator.of(context)
                      .push(route); // Prints the corresponding ID
                },
              style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  fontSize: 18)),
        );
      } else {
        textSpans.add(TextSpan(text: '$word '));
      }
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style:
            DefaultTextStyle.of(context).style, // Apply the default text style
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.post.profilePicture!),
                radius: 20.0,
              ),
              const SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.post.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  const SizedBox(height: 5.0),
                  Text(convertToLocalTime(widget.post.createdAt))
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                // ignore: prefer_is_empty
                widget.post.mention?.list.length != 0
                    ? parseDescription(
                        widget.post.description!, widget.post.mention!)
                    : widget.post.description!,
                style: const TextStyle(fontSize: 15.0)),
          ),
          if (widget.post.shared != null)
            Container(
              //color: const Color.fromARGB(110, 222, 221, 221),
              decoration: const BoxDecoration(
                color: Color.fromARGB(110, 222, 221,
                    221), // Set the desired background color here
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              widget.post.parentpostauthor.profilePicture!),
                          radius: 20.0,
                        ),
                        const SizedBox(width: 7.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.post.parentpostauthor.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                            const SizedBox(height: 5.0),
                            Text(convertToLocalTime(
                                widget.post.parentpost!.createdAt))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: parseDescriptionWidget(
                          widget.post.parentpost!.description!,
                          widget.post.parentpost!.mention!),
                    ),
                  ),
                ],
              ),
            ),
          //const SizedBox(height: 5.0),

          ImageGrid(
              imageUrls: (widget.post.shared == null)
                  ? widget.post.photoUrl!.split(',')
                  : widget.post.parentpost!.photoUrl!.split(',')),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 25,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 7.5,
                            child: Image(
                              image: AssetImage("assets/images/love.gif"),
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Image(
                            image: AssetImage("assets/images/haha.gif"),
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Text(
                        ' ${int.parse(widget.post.likecount!) + int.parse(widget.post.hahacount!) + int.parse(widget.post.lovecount!) + int.parse(widget.post.sadcount!) + int.parse(widget.post.poopcount!)}'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(int.parse(widget.post.commentCount!) < 2
                        ? '${widget.post.commentCount} comment  •  '
                        : '${widget.post.commentCount} comments  •  '),
                    Text('${widget.post.sharedCount} shares'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      key: key,
                      onLongPress: () {
                        CustomAnimatedFlutterReaction().showOverlay(
                            context: context,
                            key: key,
                            onReaction: (val) {
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(
                              //         SnackBar(content: Text("$val")));
                            });
                      },
                      child: Row(
                        children: <Widget>[
                          LikeButton(
                            size: 35,
                            circleColor: CircleColor(
                                start: ColorSplash.getColorPalette(0)
                                    .circleColorStart,
                                end: ColorSplash.getColorPalette(0)
                                    .circleColorEnd),
                            bubblesColor: BubblesColor(
                                dotPrimaryColor: ColorSplash.getColorPalette(0)
                                    .dotPrimaryColor,
                                dotSecondaryColor:
                                    ColorSplash.getColorPalette(0)
                                        .dotSecondaryColor),
                            likeBuilder: (bool isLiked) {
                              return UserReaction();
                            },
                            likeCount: null,
                          ),
                          const SizedBox(width: 5.0),
                          const Text('Like', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //debugPrint('open bottom sheet');
                        showStickyFlexibleBottomSheet(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          )),
                          minHeight: 0,
                          initHeight: 0.67,
                          maxHeight: 0.95,
                          anchors: [0, 0.5, 0.95],
                          headerHeight: 50,
                          context: context,
                          bottomSheetColor: Colors.white,
                          headerBuilder: (BuildContext context, double offset) {
                            return AppBar(
                                automaticallyImplyLeading: true,
                                title: const Column(
                                  children: [
                                    Row(
                                      children: [Text('Comments')],
                                    ),
                                  ],
                                ));
                          },
                          bodyBuilder: (BuildContext context, double offset) {
                            return SliverChildListDelegate(
                              <Widget>[
                                Container(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          CommentObj(
                                            postId: widget.post.id,
                                            showLines: false,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.message, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Comment', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.share, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Share', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
