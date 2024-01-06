import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import 'package:teamfinder_mobile/widgets/misc/image_grid.dart';
import 'package:teamfinder_mobile/widgets/misc/textfield_tag.dart';

import '../../services/mention_service.dart';
import '../simplyMention/simply_mention_interface.dart';

// ignore: must_be_immutable
class ShareBottomSheet extends StatefulWidget {
  PostPojo post;
  ShareBottomSheet({super.key, required this.post});

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  double sheetHeight = .82;
  double containerHeight = .28;

  final FocusNode mentionFocusNode = FocusNode();

  GlobalKey mentionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (mentionFocusNode.hasFocus) {
        setState(() {
          sheetHeight = .97;
          containerHeight = .43;
        });
      }
    }
    super.didChangeDependencies();
  }

  void quickSharePost() async {
    debugPrint("field is empty i.e quick share");
    debugPrint("immidiate post id:${widget.post.id.toString()}");
    debugPrint("parent post id: ${widget.post.shared.toString()}");
    int? idToSend = widget.post.shared ?? widget.post.id;

    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    //debugPrint(widget.friendId.toString());
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/quickSharePost',
      data: {'originalPostId': idToSend},
      options: options,
    );
    if (response.statusCode == 200) {
      final userService =
          // ignore: use_build_context_synchronously
          Provider.of<ProviderService>(context, listen: false);
      userService.getOwnPost();
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Post Shared!!!',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        //autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    }
  }

  void shareToFeed(List<dynamic> opsList) async {
    setState(() {
      mentionKey = GlobalKey();
    });
    int? idToSend = widget.post.shared ?? widget.post.id;
    debugPrint(opsList.toString());
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    //debugPrint(widget.friendId.toString());
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/shareToFeed',
      data: {
          'data': {
            'id': idToSend,
            'tags': [],
            'desc': {
              'content': {'ops': opsList},
            }
          }
      },
      options: options,
    );
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Post Shared!!!',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    }
  }

  Widget parseDescriptionWidget(
      String desc, Mention mentionList, BuildContext context) {
    String sanitizedDesc = desc.substring(0, desc.length - 1);
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
            recognizer: TapGestureRecognizer()..onTap = () {},
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

  String convertToLocalTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
  }

  Widget postShowcase(PostPojo post) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
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
          ),
          //const SizedBox(height: 20.0),
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
                    padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final mentionService = Provider.of<MentionService>(context, listen: true);
    final notiObserver =Provider.of<NotificationWizard>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: userService.darkTheme!
              ? const Color.fromRGBO(46, 46, 46, 1)
              : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //border: Border.all(color: Colors.red),
        ),
        height: MediaQuery.of(context).size.height * sheetHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 60,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(userService
                                    .user["profilePicture"] ??
                                "https://cdn-icons-png.flaticon.com/512/1985/1985782.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userService.user["name"],
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Sharing to your wall!!",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (mentionService.markUpText.isEmpty) {
                        debugPrint("empty");
                        quickSharePost();
                      } else {
                        debugPrint("not-empty");
                        shareToFeed(mentionService.deltaParser());
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/launch.png"))),
                            )
                          ],
                        ),
                        const Text(
                          "Share Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const TextFieldTagInterface(
              showHelperText: false,
            ),
            SimplyMentionInterface(
              key: mentionKey,
              focusNode: mentionFocusNode,
              mentionableList: notiObserver.mentionAbleList,
            ),
            Divider(
              height: 0,
              color: userService.darkTheme! ? Colors.white : Colors.grey,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              height: MediaQuery.of(context).size.height * containerHeight,
              child: SingleChildScrollView(
                child: postShowcase(widget.post),
              ),
            ),
            Divider(
              height: 0,
              color: userService.darkTheme! ? Colors.white : Colors.grey,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Or Share via...",
                        style: TextStyle(
                            color: userService.darkTheme!
                                ? Colors.white
                                : const Color.fromRGBO(46, 46, 46, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 10, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("assets/images/whatsapp.png"),
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage("assets/images/messenger.png"),
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("assets/images/telegram.png"),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: userService.darkTheme! ? Colors.white : Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
