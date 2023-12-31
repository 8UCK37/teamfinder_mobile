import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/simplyMention/simply_mention_interface.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../services/mention_service.dart';
import '../utils/image_helper.dart';
import '../utils/picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Iterable<ImageFile> selectedImages = [];

  final imagePickerController = MultiImagePickerController(
      maxImages: 5,
      picker: (allowMultiple) async {
        return await pickImagesUsingImagePicker(allowMultiple);
      });
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
    imagePickerListener();
    super.didChangeDependencies();
  }

  void imagePickerListener() {
    imagePickerController.addListener(() {
      if (imagePickerController.images.isNotEmpty) {
        setState(() {
          selectedImages = imagePickerController.images;
        });
      } else if (imagePickerController.hasNoImages) {
        setState(() {
          selectedImages = [];
        });
      }
    });
  }

  void uploadPostFiles(List<dynamic> opsList) async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
        'contentType': 'multipart/form-data'
      },
    );
    try {
      FormData formData = FormData();

      ///IMPORTANT have to  do this map thingy before we foreach append each image file
      ///or this will overwrite every file added
      formData = FormData.fromMap({
        'data': jsonEncode({
          'data': [],
          'desc': {
            'content': {'ops': opsList}
          }
        }),
      });
      int index = 0;
      for (ImageFile image in selectedImages) {
        File compressedImage = await ImageHelper.compressImage(
            image.path!, 25, "compressedPostImageNo$index");
        index = index + 1;
        formData.files.add(MapEntry(
            'post', await MultipartFile.fromFile(compressedImage.path)));
      }

      //TODO change the url to "createPost"
      Response response = await dio.post(
        'http://${dotenv.env['server_url']}/testPost',
        data: formData,
        options: options,
      );
      if (response.statusCode == 200) {
        debugPrint("post uploaded with: ${response.statusCode.toString()}");
        setState(() {
          //clear images after upload
          imagePickerController.clearImages();
          setState(() {
            mentionKey = GlobalKey();
          });
        });
      } else {
        debugPrint('failed with: ${response.statusCode.toString()}');
      }
    } catch (error) {
      debugPrint('Error from create_post_page line 91: $error');
    }
  }

  Widget pickImageTapRegion() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            imagePickerController.pickImages();
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: Colors.green)),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 30, color: Colors.green),
                  SizedBox(height: 4),
                  Text('ADD IMAGES',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                          fontSize: 14))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final mentionService = Provider.of<MentionService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
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
                              onTap: () async {
                                debugPrint(
                                    "markUpText: ${mentionService.markUpText}");
                                uploadPostFiles(mentionService.deltaParser());
                              },
                              child: Card(
                                elevation: 3,
                                surfaceTintColor: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "POST",
                                    style: TextStyle(
                                        color:
                                            mentionService.markUpText.isEmpty &&
                                                    selectedImages.isEmpty
                                                ? Colors.grey
                                                : Colors.blue),
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
                                    "",
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
              SimplyMentionInterface(key: mentionKey),
              Expanded(
                child: MultiImagePickerView(
                  controller: imagePickerController,
                  initialWidget: pickImageTapRegion(),
                  addMoreButton: DefaultAddMoreWidget(
                    icon: Icon(
                      color: userService.darkTheme!? Colors.grey:Colors.white,
                      Icons.add,
                    ),
                    backgroundColor: const Color.fromARGB(255, 154, 223, 156),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          )),
    );
  }
}
