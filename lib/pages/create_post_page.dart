import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/widgets/imageSlideshow.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late TextEditingController textController;
  final FocusNode _focusNode = FocusNode();
  String checkIfEmpty = '';
  List<String> selectedImages = [];

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

  void selectImageFile() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 75);

    if (pickedImages.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedImages.map((image) => image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blue)),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8),
                  child: TextField(
                    maxLength: 1000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    focusNode: _focusNode,
                    controller: textController,
                    decoration: const InputDecoration(
                                hintText: "Type away...",
                                border: InputBorder.none),
                    minLines: 1,
                    maxLines: 7,
                    onChanged: (value) {
                        setState(() {
                          checkIfEmpty = value;
                          });
                      },
                    
                  ),
                ),
              ),
            ),

            Visibility(
              visible:selectedImages.isNotEmpty,
              child: ImageSlideshow(
                initialPage: 0,
                width: MediaQuery.of(context).size.width,
                indicatorRadius: 5,
                indicatorColor: Colors.red,
                indicatorBackgroundColor: Colors.grey,
                isLoop: selectedImages.length > 1,
                children: selectedImages.map(
                      (e) => ClipRect(
                          child: Image.file(
                            File(e),
                            fit:BoxFit.fill
                            )
                      ),
                    )
                    .toList(),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    selectImageFile();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          color: Color.fromARGB(255, 130, 210, 133),
                          shadowColor: Colors.green,
                          surfaceTintColor:
                              Color.fromARGB(255, 130, 210, 133),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.add_photo_alternate_rounded),
                                Text("Add Photo")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        )
    );
  }
}