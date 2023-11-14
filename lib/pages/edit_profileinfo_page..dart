import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/language_selectbottomsheet.dart';

import '../services/data_service.dart';
import '../utils/chip_helper.dart';

class EditProfileInfo extends StatefulWidget {
  const EditProfileInfo({super.key});

  @override
  State<EditProfileInfo> createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  final TextEditingController genderController = TextEditingController();
  GenderLabel? selectedGender = GenderLabel.idk;

  final FocusNode bioTextArea = FocusNode();
  final TextEditingController _textControllerbio = TextEditingController();
  late String bioHint;

  final FocusNode addressTextArea = FocusNode();
  final TextEditingController _textControlleraddress = TextEditingController();
  late String addressHint;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textControllerbio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final userData = userService.user;
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
        backgroundColor: Colors.white,
        elevation: 0.0,
        //systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            children: [
              const Divider(color: Colors.black, height: 7),
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Profile Picture",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['profilePicture']),
                        radius: 80,
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Divider(
                    color: Colors.black,
                    height: 7,
                    indent: 8,
                    endIndent: 8,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Banner",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width *
                            .9, // Set the desired fixed height for the banner
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                userData['profileBanner']),
                            fit: BoxFit
                                .cover, // Set the fit property to determine how the image should be fitted
                          ),
                        ),
                      ),
                    ],
                  )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Bio",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(bioTextArea);
                      },
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit),
                          )
                        ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Address",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(addressTextArea);
                      },
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit),
                          )
                        ],
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
                            textStyle: TextStyle(color: selectedGender!.color),
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
                            debugPrint("save lingo preff");
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.save),
                          ),
                        ),
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
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
