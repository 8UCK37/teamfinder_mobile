import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/language_selectbottomsheet.dart';

import '../../services/data_service.dart';
import '../../utils/language_chip_helper.dart';

class EditProfileInfo extends StatefulWidget {
  const EditProfileInfo({super.key});

  @override
  State<EditProfileInfo> createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  final TextEditingController genderController = TextEditingController();
  GenderLabel? selectedGender = GenderLabel.idk;

  final FocusNode nameTextArea = FocusNode();
  final TextEditingController _textControllername = TextEditingController();
  late String nameHint;

  final FocusNode bioTextArea = FocusNode();
  final TextEditingController _textControllerbio = TextEditingController();
  late String bioHint;

  final FocusNode addressTextArea = FocusNode();
  final TextEditingController _textControlleraddress = TextEditingController();
  late String addressHint;

  File? _selectedBanner;
  String? selectedBannerPath;
  File? _selectedProfilePic;
  String? selectedProfilePicPath;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textControllerbio.dispose();
    super.dispose();
  }

  Future<void> pickImage(String type) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (type == "banner") {
        _selectedBanner = File(pickedImage!.path);
        selectedBannerPath = pickedImage.path;
      } else if (type == "dp") {
        _selectedProfilePic = File(pickedImage!.path);
        selectedProfilePicPath = pickedImage.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final userData = userService.user;
    String nameHint = userData['name'] ?? 'wtf';
    String bioHint = userData['bio'] ?? 'Add a bio';
    String addressHint = userData['address'] ?? 'Add your Location';

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
            debugPrint("saveChanges");
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
        body: SingleChildScrollView(
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
                                image: FileImage(_selectedBanner!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: CachedNetworkImageProvider(
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
                        child: const Icon(Icons.edit),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImage("dp");
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 105, top: 170),
                        child: Icon(Icons.edit),
                      ),
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 150),
                            child: selectedProfilePicPath != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(_selectedProfilePic!),
                                    radius: 50.0,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(userData['name'] ?? 'person doe',
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(userData['bio'] ?? 'No Bio Given',
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
                  )
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
