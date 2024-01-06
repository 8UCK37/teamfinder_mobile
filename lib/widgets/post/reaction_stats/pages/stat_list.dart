import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';

import '../../../../services/data_service.dart';
import '../../../../utils/router_animation.dart';

class ReactionList extends StatefulWidget {
  final List<dynamic> reactionList;
  final String? type;
  const ReactionList({super.key, required this.reactionList, this.type});

  @override
  State<ReactionList> createState() => _ReactionListState();
}

class _ReactionListState extends State<ReactionList> {

  String reactionPathFromType(String type) {
        switch (type) {
          case "like":
            return "assets/images/fire.gif";
          case "haha":
            return "assets/images/haha.gif";
          case "sad":
            return "assets/images/sad.gif";
          case "love":
            return "assets/images/love.gif";
          case "poop":
            return "assets/images/poop.gif";
          default:
            return "null";
        }
  }



  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                    color:
                        userService.darkTheme! ? Colors.white : Colors.black),
                text: widget.type!=null? "${widget.type}: ":"All: ",
              ),
              TextSpan(
                  style: const TextStyle(color: Colors.blue),
                  text: "${widget.reactionList.length}"),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 15, 5),
          child: ListView.builder(
            itemCount: widget.reactionList.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  debugPrint(widget.reactionList[i]['author']);
                  if (userService.user['id'] !=
                      widget.reactionList[i]['author']) {
                    AnimatedRouter.slideToPageLeft(
                        context,
                        FriendProfileHome(
                          friendId: widget.reactionList[i]['author'],
                          friendName: widget.reactionList[i]['name'],
                          friendProfileImage: widget.reactionList[i]
                              ['profilePicture'],
                        ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent)),
                        child: Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.reactionList[i]['profilePicture']),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Image(
                                image: AssetImage(widget.type != null
                                    ? "assets/images/${widget.type}.gif"
                                    : reactionPathFromType(
                                        widget.reactionList[i]['type'])),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: userService.darkTheme!
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                            text: userService.user['id'] ==
                                    widget.reactionList[i]['author']
                                ? "You"
                                : widget.reactionList[i]['name'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
