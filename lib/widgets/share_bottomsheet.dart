import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class ShareBottomSheet extends StatefulWidget {
  const ShareBottomSheet({super.key});

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            //border: Border.all(color: Colors.red),
          ),
          height: MediaQuery.of(context).size.height * .8,
          child: Column(
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
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color:Colors.blue)),
                  child: Row(
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
                            const Text("Sharing to your feed!!",
                              style:  TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height:50,
                              width: 50,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/launch.png"))
                              ),
                            )
                            ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
  }
}