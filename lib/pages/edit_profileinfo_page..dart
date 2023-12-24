// ignore: file_names
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:teamfinder_mobile/widgets/profile_image_cropper.dart';
import 'package:teamfinder_mobile/widgets/language_selectbottomsheet.dart';
import '../controller/network_controller.dart';
import '../services/data_service.dart';
import '../utils/image_helper.dart';
import '../utils/language_chip_helper.dart';

class EditProfileInfo extends StatefulWidget {
  const EditProfileInfo({super.key});

  @override
  State<EditProfileInfo> createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  final TextEditingController genderController = TextEditingController();
  GenderLabel? selectedGender = GenderLabel.idk;

  bool cancelVisibilityBanner = true;
  bool cancelVisibilityAvatar = true;

  final FocusNode nameTextArea = FocusNode();
  final TextEditingController _textControllername = TextEditingController();
  String namePlaceholder = '';
  late String nameHint = 'wtf';

  final FocusNode bioTextArea = FocusNode();
  final TextEditingController _textControllerbio = TextEditingController();
  late String bioPlaceholder = '';
  late String bioHint = "Add bio";

  final FocusNode countryTextArea = FocusNode();
  final TextEditingController _textControllerCountry = TextEditingController();
  late String countryPlaceholder = '';
  late String countryHint = 'Add Country';

  final FocusNode addressTextArea = FocusNode();
  final TextEditingController _textControlleraddress = TextEditingController();
  late String addressPlaceholder = '';
  late String addressHint = 'Add Address';

  String? selectedBannerPath;

  String? selectedProfilePicPath;

  bool isLoading = false;
  NetworkController networkController = NetworkController();
  @override
  void initState() {
    super.initState();
    bioInitHandler();
  }

  @override
  void dispose() {
    _textControllerbio.dispose();
    super.dispose();
  }

  Future<void> pickImage(String type) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      if (type == "banner") {
        selectedBannerPath = pickedImage.path;
        cancelVisibilityBanner = true;
      } else if (type == "dp") {
        selectedProfilePicPath = pickedImage.path;
        cancelVisibilityAvatar = true;
      }
    });
  }

  void handleUpload() async {
    updateBio();
    updateName();
    updateUserInfo();
    if (selectedBannerPath != null && selectedProfilePicPath != null) {
      uploadBanner();
      uploadProfilePic();
    } else if (selectedBannerPath != null) {
      uploadBanner();
    } else if (selectedProfilePicPath != null) {
      uploadProfilePic();
    } else {
      debugPrint("name+bio+address+gender+pref lingo");
    }
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.reloadUser(context);
    nameTextArea.unfocus();
    bioTextArea.unfocus();
    addressTextArea.unfocus();
  }

  Future<void> updateBio() async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }
    Dio dio = Dio();

    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/updateBio',
      data: {'bio': bioPlaceholder},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("bio updated");
    }
  }

  Future<void> updateName() async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }
    Dio dio = Dio();

    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/userNameUpdate',
      data: {'name': namePlaceholder},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("name updated");
    }
  }

  Future<void> updateUserInfo() async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }
    // ignore: use_build_context_synchronously
    final userService = Provider.of<ProviderService>(context, listen: false);
    
    Dio dio = Dio();
    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/updateUserData',
      data: {
        'data': {
          'id': userService.user['userInfo']['id'],
          'Address': addressPlaceholder,
          'Country': countryPlaceholder,
          'Gender': 'male',
          'Language': userService.convertSelectedLangToString()
        }
      },
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("userinfo updated");
    }
  }

  void bioInitHandler() {
    final userService = Provider.of<ProviderService>(context, listen: false);
    final userData = userService.user;
    //debugPrint(userData['userInfo'].toString());
    nameHint = userData['name'];
    namePlaceholder = userData['name'];
    bioHint = userData['bio'] ?? 'Add a bio';
    bioPlaceholder = userData['bio'] ?? '';
    countryHint = userData['userInfo']['Country'] ?? 'Add your Country';
    countryPlaceholder = userData['userInfo']['Country'] ?? '';
    addressHint = userData['userInfo']['Address'] ?? 'Add your Address';
    addressPlaceholder = userData['userInfo']['Address'] ?? '';
  }

  void uploadBanner() async {
    debugPrint("banner upload hit");
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
      File compressedImage = await ImageHelper.compressImage(
          selectedBannerPath!, 25, "compressedBanner");
      FormData formData = FormData.fromMap({
        'banner': await MultipartFile.fromFile(compressedImage.path),
      });

      Response response = await dio.post(
        'http://${dotenv.env['server_url']}/uploadBanner',
        data: formData,
        options: options,
      );

      if (response.statusCode == 200) {
        debugPrint("banner upload succ");
        setState(() {
          cancelVisibilityBanner = false;
          selectedBannerPath = null;
        });
        // ignore: use_build_context_synchronously
        final userService =
            Provider.of<ProviderService>(context, listen: false);
        userService.refreashCache();
      } else {
        debugPrint('failed with: ${response.statusCode.toString()}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  void uploadProfilePic() async {
    debugPrint("profilepic upload hit");
    setState(() {
      cancelVisibilityAvatar = false;
    });
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
      File compressedImage = await ImageHelper.compressImage(
          selectedProfilePicPath!, 25, "compressedAvatar");
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(compressedImage.path),
      });

      Response response = await dio.post(
        'http://${dotenv.env['server_url']}/uploadProfile',
        data: formData,
        options: options,
      );
      if (response.statusCode == 200) {
        debugPrint("profile upload succ");
        setState(() {
          cancelVisibilityAvatar = false;
          selectedProfilePicPath = null;
        });

        // ignore: use_build_context_synchronously
        final userService =
            Provider.of<ProviderService>(context, listen: false);
        userService.refreashCache();
      } else {
        debugPrint('failed with: ${response.statusCode.toString()}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final userData = userService.user;

    final List<DropdownMenuEntry<GenderLabel>> genderEntries =
        <DropdownMenuEntry<GenderLabel>>[];
    for (final GenderLabel color in GenderLabel.values) {
      genderEntries.add(
        DropdownMenuEntry<GenderLabel>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }

    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            setState(() {
              isLoading = true;
            });
            debugPrint("saveChanges");
            Future.delayed(const Duration(seconds: 1), () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Wait a moment !!!',
                  showConfirmBtn: false,
                  autoCloseDuration: const Duration(seconds: 1));
              setState(() {
                isLoading = false;
              });
              Future.delayed(const Duration(seconds: 1), () {
                handleUpload();
              });
            });
          },
          child: const Material(
            elevation: 20,
            shape: CircleBorder(),
            child: ClipOval(
              child: CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                radius: 25,
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  userService.darkTheme! ? Brightness.light : Brightness.dark),
          backgroundColor: userService.darkTheme!
              ? const Color.fromRGBO(46, 46, 46, 1)
              : Colors.white,
          foregroundColor:
              userService.darkTheme! ? Colors.white : Colors.deepPurple,
          title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('TeamFinder',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ]),

          elevation: 0.0,
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: [
                  const Divider(color: Colors.black, height: 7),
                  Stack(
                    children: <Widget>[
                      Container(
                        height:
                            200.0, // Set the desired fixed height for the banner
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          image: selectedBannerPath != null
                              ? DecorationImage(
                                  image: FileImage(File(selectedBannerPath!)),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      cacheKey: userService.bannerImagecacheKey,
                                      userData['profileBanner'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      //const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          pickImage("banner");
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width - 30,
                              top: 8),
                          child: const Icon(Icons.add_a_photo),
                        ),
                      ),
                      Visibility(
                        visible: selectedBannerPath != null &&
                            cancelVisibilityBanner,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("deselect banner");
                            setState(() {
                              selectedBannerPath = null;
                              cancelVisibilityBanner = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, top: 8),
                            child: Icon(Icons.cancel),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedProfilePicPath != null &&
                            cancelVisibilityAvatar,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedProfilePicPath = null;
                              cancelVisibilityAvatar = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 45, top: 125),
                            child: Icon(Icons.cancel),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedProfilePicPath != null &&
                            cancelVisibilityAvatar,
                        child: GestureDetector(
                          onTap: () async {
                            debugPrint("goto crop");

                            if (selectedProfilePicPath != null) {
                              var editedImage = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      CropperScreen(
                                    imagePath: selectedProfilePicPath!,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                              if (editedImage != null) {
                                String newImagePath =
                                    await ImageHelper.saveEditedImage(
                                        editedImage, "profile_image");
                                setState(() {
                                  selectedProfilePicPath = newImagePath;
                                });
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 150, top: 170),
                            child: Icon(Icons.crop),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          pickImage("dp");
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 105, top: 170),
                          child: Icon(Icons.add_a_photo),
                        ),
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, top: 150),
                              child: selectedProfilePicPath != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(
                                          File(selectedProfilePicPath!)),
                                      radius: 50.0,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              cacheKey: userService
                                                  .profileImagecacheKey,
                                              userData['profilePicture'] ?? ''),
                                      radius: 50.0,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 200, left: 10),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              //decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                              width: MediaQuery.of(context).size.width - 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          namePlaceholder.isEmpty
                                              ? nameHint
                                              : namePlaceholder,
                                          style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          bioPlaceholder.isEmpty
                                              ? bioHint
                                              : bioPlaceholder,
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.normal))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(
                        color: Colors.black,
                        height: 7,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Display Name",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextField(
                            focusNode: nameTextArea,
                            controller: _textControllername,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                namePlaceholder = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 83, 13,
                                        95), // Change the color to your desired color
                                    width: 2.0, // Set the width of the border
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                hintText: nameHint,
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),
                      ],
                    )
                  ]),
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(
                        color: Colors.black,
                        height: 7,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Bio",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextField(
                            focusNode: bioTextArea,
                            controller: _textControllerbio,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                bioPlaceholder = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 83, 13,
                                        95), // Change the color to your desired color
                                    width: 2.0, // Set the width of the border
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                hintText: bioHint,
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),
                      ],
                    )
                  ]),
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(
                        color: Colors.black,
                        height: 7,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Country",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextField(
                            focusNode: countryTextArea,
                            controller: _textControllerCountry,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                countryPlaceholder = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 83, 13,
                                        95), // Change the color to your desired color
                                    width: 2.0, // Set the width of the border
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                hintText: countryHint,
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(
                        color: Colors.black,
                        height: 7,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: sized_box_for_whitespace
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          width: MediaQuery.of(context).size.width * .9,
                          child: TextField(
                            focusNode: addressTextArea,
                            controller: _textControlleraddress,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                addressPlaceholder = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 83, 13,
                                        95), // Change the color to your desired color
                                    width: 2.0, // Set the width of the border
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                hintText: addressHint,
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Divider(
                          color: Colors.black,
                          height: 7,
                          indent: 8,
                          endIndent: 8,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * .9,
                              //decoration: BoxDecoration(border:Border.all(color:Colors.red)),
                              child: DropdownMenu<GenderLabel>(
                                textStyle:
                                    TextStyle(color: selectedGender!.color),
                                initialSelection: GenderLabel
                                    .idk, //TODO:interfacetyhis with a changing variable acc to the db value
                                controller: genderController,
                                label: const Text('Gender'),
                                dropdownMenuEntries: genderEntries,
                                onSelected: (GenderLabel? gender) {
                                  setState(() {
                                    selectedGender = gender;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 23.0),
                      child: Divider(
                        color: Colors.black,
                        height: 7,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Preffered Languages",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return const Wrap(
                                        children: [LanguageBottomSheet()]);
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.edit),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChipHelper(),
                          ],
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
          // Blurry overlay when isLoading is true
          if (isLoading)
            Container(
              color:
                  Colors.black.withOpacity(0.5), // Adjust the opacity as needed
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5), // Adjust the blur amount
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

enum GenderLabel {
  male('Male', Colors.blue),
  female('Female', Colors.pink),
  idk('Prefer not to say', Colors.grey),
  rainbow('LGTV', Colors.black);

  const GenderLabel(this.label, this.color);
  final String label;
  final Color? color;
}
