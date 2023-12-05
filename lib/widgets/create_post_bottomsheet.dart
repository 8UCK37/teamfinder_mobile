import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late TextEditingController textController;
  final FocusNode _focusNode = FocusNode();
  String checkIfEmpty = '';
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

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: MediaQuery.of(context).size.height-25,
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            toolbarHeight: 50,
            automaticallyImplyLeading: true,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: userService.darkTheme!
                    ? Brightness.light
                    : Brightness.dark),
            backgroundColor: userService.darkTheme!
                ? const Color.fromRGBO(46, 46, 46, 1)
                : Colors.white,
            foregroundColor:
                userService.darkTheme! ? Colors.white : Colors.deepPurple,
            title: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Text('Create Post',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                debugPrint(
                                    'this is the text: ${textController.text}');
                              },
                              child: Card(
                                elevation: 3,
                                surfaceTintColor: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "POST",
                                    style: TextStyle(
                                        color: checkIfEmpty.isNotEmpty
                                            ? Colors.blue
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ]),
              ],
            ),
            elevation: 0.0,
          ),
          body: Column(
            children: [
              const Divider(
                height: 5,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
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
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldTapRegion(
                        onTapInside: (event) {},
                        onTapOutside: (event) {},
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          //decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
                          height: 230,
                          width: MediaQuery.of(context).size.width - 25,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0),
                            child: TextField(
                              focusNode: _focusNode,
                              controller: textController,
                              onChanged: (value) {
                                setState(() {
                                  checkIfEmpty = value;
                                });
                              },
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
            ],
          )),
    );
  }
}
