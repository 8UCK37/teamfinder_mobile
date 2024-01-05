import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../friend_profile_ui/friend_profilehome.dart';
import '../../../../services/data_service.dart';
import '../../../../services/reaction_stat_service.dart';
import '../../../../utils/router_animation.dart';

class FirstStat extends StatefulWidget {
  const FirstStat({super.key});

  @override
  State<FirstStat> createState() => _FirstStatState();
}

class _FirstStatState extends State<FirstStat> {

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
    final reactionService =
        Provider.of<ReactionStatService>(context, listen: true);
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
                  color: userService.darkTheme!?Colors.white:Colors.black
                ),
                text:"total: ",
              ),
              TextSpan(
                style: const TextStyle(
                  color: Colors.blue
                ),
                text: "${reactionService.allReactionList.length}"
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,20,15,5),
          child: ListView.builder(
              itemCount: reactionService.allReactionList.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    debugPrint(reactionService.allReactionList[i]['author']);
                  if (userService.user['id'] != reactionService.allReactionList[i]['author']) {
                    AnimatedRouter.slideToPageLeft(
                        context,
                        FriendProfileHome(
                          friendId: reactionService.allReactionList[i]['author'],
                          friendName: reactionService.allReactionList[i]['name'],
                          friendProfileImage: reactionService.allReactionList[i]['profilePicture'],
                        ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color:Colors.transparent)),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(border: Border.all(color:Colors.transparent)),
                          child: Stack(
                            children:[ 
                              Center(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                      reactionService.allReactionList[i]['profilePicture']),
                                ),
                              ),
                               Align(
                                alignment: Alignment.bottomRight,
                                child: Image(
                                  image: AssetImage(reactionPathFromType(reactionService.allReactionList[i]['type'])),
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: userService.darkTheme!?Colors.white:Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                              text: userService.user['id'] ==
                                    reactionService.allReactionList[i]['author']
                                ? "You"
                                : reactionService.allReactionList[i]['name'],
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
