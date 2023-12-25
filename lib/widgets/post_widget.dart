// ignore_for_file: sort_child_properties_last
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat_widgets/chat_message_bar.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/widgets/comment_widgets/comment_tree.dart';
import 'package:teamfinder_mobile/widgets/image_grid.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/custom_animated_reaction.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';
import 'package:teamfinder_mobile/widgets/share_bottomsheet.dart';
import 'comment_widgets/new_bottomSheet_route.dart';

class PostWidget extends StatefulWidget {
  final PostPojo post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final FocusNode chatTextArea = FocusNode();

  double iconSize = 15;
  double smallerIconPadding = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
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
                      builder: (BuildContext context) => FriendProfileHome(
                            friendId: word,
                            friendName: idNameMap[word],
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

  void newParentComment() {
    debugPrint(widget.post.id.toString());
    final userService = Provider.of<ProviderService>(context, listen: false);
    debugPrint(userService.replyingTo.toString());
    userService.updateReplyingTo(null);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    return CircularMenu(
      alignment: Alignment.topRight,
            toggleButtonSize: 15,
            toggleButtonPadding: 5,
            toggleButtonBoxShadow: [],
            radius: 35,
            animationDuration: const Duration(milliseconds: 250),
            toggleButtonColor: Colors.teal,
            items: [
              CircularMenuItem(
                  iconSize: iconSize,
                  padding: smallerIconPadding,
                  boxShadow: [],
                  icon: Icons.home,
                  color: Colors.green,
                  onTap: () {
                    setState(() {
                      
                    });
                  }),
              CircularMenuItem(
                  iconSize: iconSize,
                  padding: smallerIconPadding,
                  boxShadow: [],
                  icon: Icons.search,
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                      
                    });
                  }),
              CircularMenuItem(
                  iconSize: iconSize,
                  padding: smallerIconPadding,
                  boxShadow: [],
                  icon: Icons.settings,
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      
                    });
                  }),
            ],
      backgroundWidget: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.profilePicture!),
                    radius: 20.0,
                  ),
                  onTap: () {
                    debugPrint(widget.post.author);
                    var route = MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FriendProfileHome(
                                    friendId: widget.post.author,
                                    friendName: widget.post.name,
                                    friendProfileImage:widget.post.profilePicture,
                                  ));
                          Navigator.of(context).push(route);
                  },
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
                      : widget.post.description ?? "",
                  style: const TextStyle(fontSize: 15.0)),
            ),
            if (widget.post.shared != null)
              Container(
                decoration: BoxDecoration(
                  color: userService.darkTheme!
                      ? const Color.fromARGB(255, 80, 80, 80)
                      : const Color.fromARGB(110, 222, 221,
                          221), // Set the desired background color here
                  borderRadius: const BorderRadius.only(
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
                      padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
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
                  Divider(
                      height: 20,
                      color: userService.darkTheme! ? Colors.white : Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        key: key,
                        onLongPress: () {
                          CustomAnimatedFlutterReaction().showOverlay(
                              overlaySize:
                                  MediaQuery.of(context).size.width * .62,
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
                          final userService = Provider.of<ProviderService>(
                              context,
                              listen: false);
                          userService.updateReplyingTo(null);
                          showCustomBottomSheet(
                            minHeight: 0,
                            initHeight: 0.67,
                            maxHeight: 0.96,
                            anchors: [0, 0.67, 0.96],
                            headerHeight: 65,
                            context: context,
                            bottomWidget: Theme(
                              data: ThemeData.light(),
                              child: ChatMessageBar(
                                focusNode: chatTextArea,
                                maxLines: 10,
                                messageBarColor: userService.darkTheme!
                                    ? const Color.fromARGB(255, 74, 74, 74)
                                    : const Color.fromARGB(255, 239, 239, 239),
                                decoration: BoxDecoration(
                                    color: userService.darkTheme!
                                        ? const Color.fromARGB(255, 74, 74, 74)
                                        : const Color.fromARGB(
                                            255, 239, 239, 239),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                hintText: "Write a comment here..",
                                textController: _textController,
                                onSend: (String typedMsg) {
                                  debugPrint(typedMsg);
                                  newParentComment();
                                },
                              ),
                            ),
                            bottomSheetColor: userService.darkTheme!
                                ? const Color.fromRGBO(46, 46, 46, 1)
                                : Colors.white,
                            headerBuilder: (BuildContext context, double offset) {
                              return Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 65,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: userService.darkTheme!
                                                ? const Color.fromRGBO(
                                                    46, 46, 46, 1)
                                                : Colors.white,
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        child: Theme(
                                          data: userService.darkTheme!
                                              ? ThemeData.dark()
                                              : ThemeData.light(),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 22.0, right: 22),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 0.0),
                                                        child: Container(
                                                          height: 5,
                                                          width: 60,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              15))),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Comments",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child:
                                                                Icon(Icons.close),
                                                          ),
                                                        )
                                                      ]),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 0,
                                      color: userService.darkTheme!
                                          ? Colors.grey
                                          : const Color.fromARGB(255, 36, 36, 36),
                                    ),
                                  ],
                                ),
                              );
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
                                              chatFocus: chatTextArea,
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
                        onTap: () {
                          showModalBottomSheet<dynamic>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Wrap(children: [
                                ShareBottomSheet(
                                  post: widget.post,
                                )
                              ]);
                            },
                          );
                        },
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
      ),
    );
  }
}
