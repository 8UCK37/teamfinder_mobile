import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class MockProfile extends StatefulWidget {
  final File selectedImageFile;
  final String imagePath;
  final String type;
  const MockProfile(
      {super.key,
      required this.selectedImageFile,
      required this.imagePath,
      required this.type});

  @override
  State<MockProfile> createState() => _MockProfileState();
}

class _MockProfileState extends State<MockProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final userData = userService.user;
    return Scaffold(
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 200.0, // Set the desired fixed height for the banner
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                    image: widget.type == "banner"
                        ? DecorationImage(
                            image: FileImage(widget.selectedImageFile),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: CachedNetworkImageProvider(
                                userData['profileBanner'] ?? ''),
                            fit: BoxFit.cover,)
                    ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 150),
                      child: widget.type=="dp"?
                      CircleAvatar(
                        backgroundImage: FileImage(widget.selectedImageFile),
                        radius: 50.0,
                      )
                      :CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['profilePicture'] ?? ''),
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
              )
            ],
          ),
        ],
      )),
    );
  }
}

