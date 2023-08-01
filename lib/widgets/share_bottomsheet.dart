import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class ShareBottomSheet extends StatefulWidget {
  const ShareBottomSheet({super.key});

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  double height = .68;
  late TextEditingController textController;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void sharePost() {
    if (textController.text.length != 0) {
      debugPrint(textController.text);
    } else {
      debugPrint("field is empty i.e quick share");
    }
    QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Post Shared!!!',
          //autoCloseDuration: const Duration(seconds: 2),
        );
    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration:  BoxDecoration(
        color: userService.darkTheme!? const Color.fromRGBO(46, 46, 46, 1):Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //border: Border.all(color: Colors.red),
      ),
      height: MediaQuery.of(context).size.height * height,
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
            padding: const EdgeInsets.all(15.0),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Sharing to your feed!!",
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
                    sharePost();
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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldTapRegion(
                    onTapInside: (event) {
                      setState(() {
                        height = .88;
                      });
                    },
                    onTapOutside: (event) {
                      setState(() {
                        _focusNode.unfocus();
                        height = .68;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      //decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
                      height: 230,
                      width: MediaQuery.of(context).size.width - 25,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: textController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: "Add a post description here...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
              height: 0,
              color: userService.darkTheme! ? Colors.white : Colors.grey),
          Column(
            children: [
               Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Or Share via...",
                      style: TextStyle(
                          color: userService.darkTheme!? Colors.white:const Color.fromRGBO(46, 46, 46, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/whatsapp.png"),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage("assets/images/messenger.png"),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/telegram.png"),
                    ),
                  ],
                ),
              ),
              Divider(
                  height: 0,
                  color: userService.darkTheme! ? Colors.white : Colors.grey),
            ],
          )
        ],
      ),
    );
  }
}
