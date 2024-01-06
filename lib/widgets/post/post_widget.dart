// ignore_for_file: sort_child_properties_last
import 'package:circular_menu/circular_menu.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart' hide LikeButton, LikeButtonState;
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/pages/edit_post_page.dart';
import 'package:teamfinder_mobile/pages/individual_post_page.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_message_bar.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_header.dart';
import 'package:teamfinder_mobile/widgets/post/comment_widgets/comment_tree.dart';
import 'package:teamfinder_mobile/widgets/misc/image_grid.dart';
import 'package:teamfinder_mobile/widgets/misc/share_bottomsheet.dart';
import 'package:teamfinder_mobile/widgets/post/reaction_stats/reaction_stat.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/custom_animated_reaction.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../controller/network_controller.dart';
import '../../services/reaction_stat_service.dart';
import '../../utils/router_animation.dart';
import 'comment_widgets/new_bottomSheet_route.dart';
import 'custom_like_button.dart';

class PostWidget extends StatefulWidget {
  final PostPojo post;
  final TabController? tabController;

  const PostWidget({super.key, required this.post, this.tabController});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  GlobalKey reactionKey = GlobalKey();
  GlobalKey commentKey = GlobalKey();

  GlobalKey<CircularMenuState> circularMenuKey = GlobalKey<CircularMenuState>();

  final TextEditingController _textController = TextEditingController();
  final FocusNode chatTextArea = FocusNode();

  double iconSize = 15;
  double smallerIconPadding = 5;

  late dynamic currentReaction = widget.post.reactiontype.toString();
  late bool noReaction = widget.post.noreaction!;
  late int reactionCount = int.parse(widget.post.likecount ?? "0") +
      int.parse(widget.post.hahacount ?? "0") +
      int.parse(widget.post.lovecount ?? "0") +
      int.parse(widget.post.sadcount ?? "0") +
      int.parse(widget.post.poopcount ?? "0");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<CircularMenuItem> buildMenuItems() {
    final userService = Provider.of<ProviderService>(context, listen: true);
    bool isBookMarked = false;
    if (userService.bookMarkIds == null) {
      isBookMarked = false;
    } else {
      isBookMarked = userService.bookMarkIds!.contains(widget.post.id);
    }

    final listForOwnPost = [
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon: Icons.edit_note,
          color: Colors.green,
          onTap: () {
            circularMenuKey.currentState?.reverseAnimation();
            AnimatedRouter.slideToPageLeft(
                context, EditPost(post: widget.post));
            setState(() {});
          }),
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon: Icons.delete,
          color: const Color.fromARGB(255, 221, 61, 50),
          onTap: () {
            setState(() {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text:
                    'Do you really want to delete this post??\nnote: this is parmanent!!',
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                confirmBtnColor: Colors.red,
                showCancelBtn: true,
                backgroundColor: Colors.black,
                confirmBtnTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                barrierColor: const Color.fromARGB(107, 0, 0, 0),
                titleColor: Colors.white,
                textColor: Colors.white,
                onConfirmBtnTap: () {
                  userService.deletePost(widget.post.id);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.of(context).pop();
                    circularMenuKey.currentState?.reverseAnimation();
                  });
                },
              );
            });
          }),
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon: Icons.open_in_new,
          color: Colors.orange,
          onTap: () {
            circularMenuKey.currentState?.reverseAnimation();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualPostPage(post: widget.post),
              ),
            );
            
            setState(() {});
          }),
    ];

    final listForFeedPost = [
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon:
              isBookMarked ? Icons.bookmark_remove : Icons.collections_bookmark,
          color: isBookMarked ? Colors.red : Colors.green,
          onTap: () {
            setState(() {
              if (isBookMarked) {
                setState(() {
                  isBookMarked = false;
                });
                userService.removeFromBookmarkBox(widget.post.id);
                MotionToast(
                  icon: Icons.bookmark_remove,
                  primaryColor: const Color.fromARGB(255, 171, 132, 129),
                  displaySideBar: false,
                  displayBorder: true,
                  position: MotionToastPosition.top,
                  animationDuration: const Duration(milliseconds: 200),
                  toastDuration: const Duration(seconds: 1),
                  title: const Text(
                    'Removed!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  description: const Text(
                    'Post removed from bookmarks',
                  ),
                ).show(context);
              } else {
                setState(() {
                  isBookMarked = true;
                });
                userService.addToBookmarkBox(widget.post.id);
                MotionToast(
                  icon: Icons.bookmark_added,
                  primaryColor: Colors.green,
                  displaySideBar: false,
                  displayBorder: true,
                  position: MotionToastPosition.top,
                  animationDuration: const Duration(milliseconds: 200),
                  toastDuration: const Duration(seconds: 1),
                  title: const Text(
                    'Added!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  description: const Text(
                    'Post saved to bookmarks',
                  ),
                ).show(context);
              }
              circularMenuKey.currentState?.reverseAnimation();
            });
          }),
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon: Icons.report,
          color: const Color.fromARGB(255, 172, 47, 38),
          onTap: () {
            circularMenuKey.currentState?.reverseAnimation();
            setState(() {});
          }),
      CircularMenuItem(
          iconSize: iconSize,
          padding: smallerIconPadding,
          boxShadow: const [],
          icon: Icons.open_in_new,
          color: const Color.fromARGB(255, 58, 136, 199),
          onTap: () {
            circularMenuKey.currentState?.reverseAnimation();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualPostPage(post: widget.post),
              ),
            );

            setState(() {});
          }),
    ];

    if (widget.post.isOwnPost) {
      return listForOwnPost;
    } else {
      return listForFeedPost;
    }
  }

  String convertToLocalTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
  }

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

  Widget parseDescriptionWidget(
      String desc, Mention mentionList, BuildContext context) {
    String sanitizedDesc = desc;
    final userService = Provider.of<ProviderService>(context, listen: false);
    Map<String, String> idNameMap = {
      for (var item in mentionList.list) item['id']: item['name']
    };

    List<TextSpan> textSpans = [];

    for (var id in idNameMap.keys) {
      RegExp regex = RegExp(
          r'\b' + RegExp.escape(id) + r'\b'); // Using \b for word boundaries

      Iterable<RegExpMatch> matches = regex.allMatches(sanitizedDesc);

      int currentIndex = 0;

      for (RegExpMatch match in matches) {
        // Add regular text before the mention
        textSpans.add(
          TextSpan(
            text: sanitizedDesc.substring(currentIndex, match.start),
            style: const TextStyle(fontSize: 18),
          ),
        );

        // Add mention with tap gesture
        textSpans.add(
          TextSpan(
            text: '${idNameMap[id]} ',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint(id);
                if (userService.user['id'] != id) {
                  AnimatedRouter.slideToPageLeft(
                    context,
                    FriendProfileHome(
                      friendId: id,
                      friendName: idNameMap[id],
                    ),
                  );
                } else {
                  if (widget.tabController != null) {
                    widget.tabController!.animateTo(1);
                  }
                }
              },
            style: const TextStyle(
                color: Colors.blue, decorationColor: Colors.blue, fontSize: 18),
          ),
        );

        // Update currentIndex for the next iteration
        currentIndex = match.end;
        sanitizedDesc =
            sanitizedDesc.substring(match.end, sanitizedDesc.length);
      }
    }
    // Add remaining text after the last mention
    textSpans.add(
      TextSpan(
        text: sanitizedDesc,
        style: const TextStyle(fontSize: 18),
      ),
    );
    return RichText(
      text: TextSpan(
        children: textSpans,
        style: DefaultTextStyle.of(context).style,
      ),
    );
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    return CircularMenu(
      key: circularMenuKey,
      alignment: Alignment.topRight,
      toggleButtonSize: 15,
      toggleButtonPadding: 5,
      toggleButtonBoxShadow: const [],
      radius: 35,
      animationDuration: const Duration(milliseconds: 250),
      toggleButtonColor: Colors.teal,
      items: buildMenuItems(),
      backgroundWidget: Container(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.post.profilePicture!),
                      radius: 20.0,
                    ),
                    onTap: () {
                      debugPrint(widget.post.author);
                      if (userService.user['id'] != widget.post.author) {
                        AnimatedRouter.slideToPageLeft(
                            context,
                            FriendProfileHome(
                              friendId: widget.post.author,
                              friendName: widget.post.name,
                              friendProfileImage: widget.post.profilePicture,
                            ));
                      } else {
                        if (widget.tabController != null) {
                          widget.tabController!.animateTo(1);
                        }
                      }
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
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.post.description != null
                    ? parseDescriptionWidget(
                        widget.post.description!, widget.post.mention!, context)
                    : const Text(""),
              ),
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
                      padding:
                          const EdgeInsets.only(top: 8, left: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: parseDescriptionWidget(
                            widget.post.parentpost!.description!,
                            widget.post.parentpost!.mention!,
                            context),
                      ),
                    ),
                  ],
                ),
              ),
            //const SizedBox(height: 5.0),
            ImageGrid(
              imageUrls: (widget.post.shared == null)
                  ? widget.post.photoUrl!.split(',')
                  : widget.post.parentpost!.photoUrl!.split(','),
            ),
            const SizedBox(height: 8),
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
                            Provider.of<ReactionStatService>(context,
                                listen: false);
                        reactionService.fetchReactionStat(widget.post.id);
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
                                      image:
                                          AssetImage("assets/images/love.gif"),
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
                        Text(int.parse(widget.post.commentCount!) < 2
                            ? '${widget.post.commentCount} comment  •  '
                            : '${widget.post.commentCount} comments  •  '),
                        Text('${widget.post.sharedCount} shares'),
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
                      color:
                          userService.darkTheme! ? Colors.white : Colors.grey),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          key: reactionKey,
                          onLongPress: () {
                            CustomAnimatedFlutterReaction().showOverlay(
                              overlaySize: screenWidth * .62,
                              context: context,
                              key: reactionKey,
                              onReaction: (val) {
                                //debugPrint(val.toString());
                                setState(() {
                                  String reaction = reactionParser(val);
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
                                reactionBackendCall(currentReaction);
                              },
                            );
                          },
                          child: Container(
                            width: (screenWidth - 2) / 3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                LikeButton(
                                  width: (screenWidth - 17) / 3,
                                  onTap: (isLiked) async {
                                    setState(() {
                                      if (noReaction ||
                                          currentReaction == "dislike") {
                                        currentReaction = "like";
                                        noReaction = false;
                                      } else {
                                        currentReaction = "dislike";
                                        noReaction = true;
                                      }
                                    });
                                    debugPrint(
                                        "for postid:${widget.post.id}current:$currentReaction,noreac:$noReaction");
                                    reactionBackendCall(currentReaction);
                                    return !isLiked;
                                  },
                                  size: 35,
                                  circleColor: CircleColor(
                                      start: ColorSplash.getColorPalette(0)
                                          .circleColorStart,
                                      end: ColorSplash.getColorPalette(0)
                                          .circleColorEnd),
                                  bubblesColor: BubblesColor(
                                      dotPrimaryColor:
                                          ColorSplash.getColorPalette(0)
                                              .dotPrimaryColor,
                                      dotSecondaryColor:
                                          ColorSplash.getColorPalette(0)
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
                            final userService = Provider.of<ProviderService>(
                                context,
                                listen: false);
                            userService.updateReplyingTo(null, null);
                            openComment();
                          },
                          child: Container(
                            width: (screenWidth - 2) / 3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.message, size: 20.0),
                                  SizedBox(width: 5.0),
                                  Text('Comment',
                                      style: TextStyle(fontSize: 14.0)),
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
                                  ShareBottomSheet(
                                    post: widget.post,
                                  )
                                ]);
                              },
                            );
                          },
                          child: Container(
                            width: (screenWidth - 2) / 3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.share, size: 20.0),
                                  SizedBox(width: 5.0),
                                  Text('Share',
                                      style: TextStyle(fontSize: 14.0)),
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
    );
  }
}
