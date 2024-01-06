import 'package:carousel_images/carousel_images.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart' hide LikeButton, LikeButtonState;
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/controller/network_controller.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/reaction_stat_service.dart';
import 'package:teamfinder_mobile/widgets/misc/share_bottomsheet.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_header.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_message_bar.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_tree.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/new_bottomSheet_route.dart';
import 'package:teamfinder_mobile/widgets/post/custom_like_button.dart';
import 'package:teamfinder_mobile/widgets/post/reaction_stats/reaction_stat.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/custom_animated_reaction.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';

import '../pojos/post_pojo.dart';

class IndividualPostPage extends StatefulWidget {
  final PostPojo post;
  const IndividualPostPage({super.key, required this.post});

  @override
  State<IndividualPostPage> createState() => _IndividualPostPageState();
}

class _IndividualPostPageState extends State<IndividualPostPage> {
  GlobalKey reactionKey = GlobalKey();
  GlobalKey commentKey = GlobalKey();

  bool showOverlay = true;

  final FocusNode chatTextArea = FocusNode();
  final TextEditingController _textController = TextEditingController();

  late dynamic currentReaction = widget.post.reactiontype.toString();
  late bool noReaction = widget.post.noreaction!;

  late int reactionCount = int.parse(widget.post.likecount ?? "0") +
      int.parse(widget.post.hahacount ?? "0") +
      int.parse(widget.post.lovecount ?? "0") +
      int.parse(widget.post.sadcount ?? "0") +
      int.parse(widget.post.poopcount ?? "0");

  String reactionParser(int val) {
    String path(int i) {
      switch (i) {
        case 0:
          return "like";
        case 1:
          return "haha";
        case 2:
          return "love";
        case 3:
          return "sad";
        case 4:
          return "poop";
        default:
          return "null";
      }
    }

    return path(val);
  }

  Widget userReaction() {
    if (noReaction || currentReaction == "dislike") {
      return ShaderMask(
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
        blendMode:
            BlendMode.srcATop, // This preserves the transparency of the image.
        child: const Image(
          image: AssetImage("assets/images/fire.gif"),
          width: 45,
          height: 45,
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

      //widget.post.reactiontype
      return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Image(
          image: AssetImage(path(currentReaction)),
          width: 45,
          height: 45,
        ),
      );
    }
  }

  void reactionBackendCall(String reaction) async {
    NetworkController networkController = NetworkController();
    debugPrint("type: $reaction");
    if (await networkController.noInternet()) {
      debugPrint("reaction no_internet");
      return;
    } else {
      debugPrint("reaction called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (reaction == "dislike") {
      setState(() {
        reactionCount--;
      });
      var response = await dio.post(
        'http://${dotenv.env['server_url']}/dislikePost',
        data: {
          'id': widget.post.id,
          'type': reaction,
        },
        options: options,
      );
      if (response.statusCode == 200) {
        debugPrint("dislike for post id: ${widget.post.id} succ");
      }
    } else {
      setState(() {
        reactionCount++;
      });
      var response = await dio.post(
        'http://${dotenv.env['server_url']}/likePost',
        data: {
          'id': widget.post.id,
          'type': reaction,
        },
        options: options,
      );
      if (response.statusCode == 200) {
        debugPrint("dislike for post id: ${widget.post.id} succ");
      }
    }
  }

  void newParentComment(String msg) async {
    debugPrint("commenting on: ${widget.post.id.toString()}");
    final userService = Provider.of<ProviderService>(context, listen: false);
    debugPrint(userService.replyingToId.toString());
    var replyIngTo = userService.replyingToId;
    userService.updateReplyingTo(null, null);
    NetworkController networkController = NetworkController();

    if (await networkController.noInternet()) {
      debugPrint("reaction no_internet");
      return;
    } else {
      debugPrint("reaction called");
    }
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;

    final idToken = await user!.getIdToken();

    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/comment/add',
      data: {
        'postId': widget.post.id,
        "commentOf": replyIngTo,
        'msg': msg,
      },
      options: options,
    );
    if (response.statusCode == 200) {
      commentKey.currentState!.didChangeDependencies();
      if (chatTextArea.hasFocus) {
        chatTextArea.unfocus();
      }
      debugPrint(
          "commented on ${widget.post.id}, replying to: ${replyIngTo.toString()},with comment: $msg");
    }
  }

  void openComment() {
    showCustomBottomSheet(
      minHeight: 0,
      initHeight: 0.67,
      maxHeight: 0.96,
      anchors: [0, 0.67, 0.96],
      headerHeight: 65,
      context: context,
      bottomSheetColor: Colors.transparent,
      bottomWidget: Theme(
        data: ThemeData.light(),
        child: CommentMessageBar(
          focusNode: chatTextArea,
          maxLines: 10,
          messageBarColor: Colors.transparent,
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          hintText: "Write a comment here..",
          textController: _textController,
          onSend: (String typedMsg) {
            debugPrint(typedMsg);
            newParentComment(typedMsg);
          },
        ),
      ),
      headerBuilder: (BuildContext context, double offset) {
        return const CommentHeader();
      },
      bodyBuilder: (BuildContext context, double offset) {
        return SliverChildListDelegate(
          <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      CommentObj(
                        key: commentKey,
                        postId: widget.post.id,
                        showLines: false,
                        chatFocus: chatTextArea,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final userService = Provider.of<ProviderService>(context, listen: true);
    final double screenWidth = MediaQuery.of(context).size.width - 4;
    final double screenHeight = MediaQuery.of(context).size.height - 50;
    final List<String> imageList = (widget.post.shared == null)
        ? widget.post.photoUrl!.split(',')
        : widget.post.parentpost!.photoUrl!.split(',');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: CarouselImages(
                  scaleFactor: 0.6,
                  listImages: imageList,
                  height: screenHeight,
                  borderRadius: 5.0,
                  cachedNetworkImage: true,
                  verticalAlignment: Alignment.center,
                  onTap: (index) {
                    //debugPrint('Tapped on page $index');
                    setState(() {
                      showOverlay = !showOverlay;
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         CustomImageViewer(imageUrls: imageList),
                    //   ),
                    // );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: showOverlay,
                  child: Container(
                    height: 82,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    final reactionService =
                                        Provider.of<ReactionStatService>(
                                            context,
                                            listen: false);
                                    reactionService
                                        .fetchReactionStat(widget.post.id);
                                    showModalBottomSheet<dynamic>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Wrap(children: [
                                          ReactionStat(
                                            postId: widget.post.id,
                                          )
                                        ]);
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Visibility(
                                        visible: reactionCount > 0,
                                        child: const SizedBox(
                                          width: 25,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 7.5,
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/images/love.gif"),
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                              Image(
                                                image: AssetImage(
                                                    "assets/images/haha.gif"),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: userService.darkTheme!
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          children: [
                                            TextSpan(text: "$reactionCount"),
                                            TextSpan(
                                              text: reactionCount == 1
                                                  ? "  Reaction"
                                                  : "  Reactions",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      int.parse(widget.post.commentCount!) < 2
                                          ? '${widget.post.commentCount} comment  •  '
                                          : '${widget.post.commentCount} comments  •  ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${widget.post.sharedCount} shares',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Divider(
                                  height: 20,
                                  color: userService.darkTheme!
                                      ? Colors.white
                                      : Colors.grey),
                              Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      key: reactionKey,
                                      onLongPress: () {
                                        CustomAnimatedFlutterReaction()
                                            .showOverlay(
                                          overlaySize: screenWidth * .65,
                                          context: context,
                                          key: reactionKey,
                                          onReaction: (val) {
                                            //debugPrint(val.toString());
                                            setState(() {
                                              String reaction =
                                                  reactionParser(val);
                                              debugPrint(reaction);
                                              if (reaction != "null") {
                                                currentReaction = reaction;
                                                noReaction = false;
                                              } else {
                                                noReaction = true;
                                              }
                                            });
                                            debugPrint(
                                                "for postid:${widget.post.id}current:$currentReaction,noreac:$noReaction");
                                            reactionBackendCall(
                                                currentReaction);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: (screenWidth - 2) / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            LikeButton(
                                              width: (screenWidth - 17) / 3,
                                              onTap: (isLiked) async {
                                                setState(() {
                                                  if (noReaction ||
                                                      currentReaction ==
                                                          "dislike") {
                                                    currentReaction = "like";
                                                    noReaction = false;
                                                  } else {
                                                    currentReaction = "dislike";
                                                    noReaction = true;
                                                  }
                                                });
                                                debugPrint(
                                                    "for postid:${widget.post.id}current:$currentReaction,noreac:$noReaction");
                                                reactionBackendCall(
                                                    currentReaction);
                                                return !isLiked;
                                              },
                                              size: 35,
                                              circleColor: CircleColor(
                                                  start: ColorSplash
                                                          .getColorPalette(0)
                                                      .circleColorStart,
                                                  end: ColorSplash
                                                          .getColorPalette(0)
                                                      .circleColorEnd),
                                              bubblesColor: BubblesColor(
                                                  dotPrimaryColor: ColorSplash
                                                          .getColorPalette(0)
                                                      .dotPrimaryColor,
                                                  dotSecondaryColor: ColorSplash
                                                          .getColorPalette(0)
                                                      .dotSecondaryColor),
                                              likeBuilder: (isLiked) {
                                                return userReaction();
                                              },
                                              likeCount: null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //debugPrint('open bottom sheet');
                                        final userService =
                                            Provider.of<ProviderService>(
                                                context,
                                                listen: false);
                                        userService.updateReplyingTo(
                                            null, null);
                                        openComment();
                                      },
                                      child: Container(
                                        width: (screenWidth - 2) / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent)),
                                        child: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.message,
                                                  color: Colors.white,
                                                  size: 20.0),
                                              SizedBox(width: 5.0),
                                              Text('Comment',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0)),
                                            ],
                                          ),
                                        ),
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
                                              Theme(
                                                data: userService.darkTheme!
                                                    ? ThemeData.dark()
                                                    : ThemeData.light(),
                                                child: ShareBottomSheet(
                                                  post: widget.post,
                                                ),
                                              )
                                            ]);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: (screenWidth - 2) / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent)),
                                        child: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.share,
                                                  color: Colors.white,
                                                  size: 20.0),
                                              SizedBox(width: 5.0),
                                              Text('Share',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
