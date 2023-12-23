import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/incoming_notification.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

class NotificationOptions extends StatefulWidget {
  final IncomingNotification notification;
  const NotificationOptions({super.key, required this.notification});

  @override
  State<NotificationOptions> createState() => _NotificationOptionsState();
}

class _NotificationOptionsState extends State<NotificationOptions> {
  String notificationTextParser() {
    String notificationText = '';
    switch (widget.notification.notification) {
      case 'poke':
        notificationText = 'has poked you';
        break;
      case 'frnd req':
        notificationText = 'has sent you a friend request!!';
        break;
      case 'frndReqAcc':
        notificationText = 'has accepted your friend request!!';
        break;
      case 'new mention':
        notificationText = 'has mentioned you in a new post!!';
        break;
      case 'new comment':
        notificationText = 'has mentioned you in a new comment!!';
        break;
      default:
        notificationText = 'idk wtf this notification is!!';
    }
    return notificationText;
  }

  double height = .30;
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: false);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: userService.darkTheme!
            ? const Color.fromRGBO(46, 46, 46, 1)
            : Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //border: Border.all(color: Colors.red),
      ),
      height: MediaQuery.of(context).size.height * height,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                        widget.notification.senderProfilePicture),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text: widget.notification.senderName,
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' ${notificationTextParser()}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal))
                      ]))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10,0,0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,8.0,0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 220, 154, 214),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          children: [
                            IconButton.filledTonal(
                                onPressed: () {},
                                color: const Color.fromARGB(255, 115, 172, 220),
                                icon: const Icon(Icons.delete_sweep)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                              child: RichText(
                                  text: const TextSpan(
                                      text:"Remove this notification",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,8,0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 50, 185, 108),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          children: [
                            IconButton.filledTonal(
                                onPressed: () {},
                                color: const Color.fromARGB(255, 220, 121, 114),
                                icon: const Icon(Icons.do_not_disturb_off)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                              child: RichText(
                                  text: TextSpan(
                                      text:"Mute ${widget.notification.senderName}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
