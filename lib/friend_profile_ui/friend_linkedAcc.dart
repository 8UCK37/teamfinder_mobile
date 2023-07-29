import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';


class FriendLinkedAcc extends StatefulWidget {
  final String? friendName;
  final String? friendId;
  final String? friendProfileImage;
  const FriendLinkedAcc(
      {super.key,
      required this.friendName,
      required this.friendId,
      required this.friendProfileImage});

  @override
  State<FriendLinkedAcc> createState() => _FriendLinkedAccState();
}

class _FriendLinkedAccState extends State<FriendLinkedAcc> {
  dynamic steamData;
  dynamic twitchData;
  dynamic discordData;
  @override
  Widget build(BuildContext context) {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    steamData = profileService.steamData;
    return SafeArea(
        child: Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, bottom: 10, left: 15, right: 15),
        child: Material(
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 91, 164, 224),
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(widget.friendProfileImage!)),
                    ),
                    CustomPaint(
                      willChange: true,
                      painter: _MainLinePainter(yCoordinate: 45),
                    ),
                    CustomPaint(
                      willChange: true,
                      painter: _MainLinePainter(yCoordinate: 175),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 58, top: 45),
                  child: Column(
                    children: [
                      Card(
                        elevation: 20,
                        child: Column(children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("assets/images/steam.png"),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Steam",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 32, 133, 216),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Container(
                                  height:40,
                                  width:40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(steamData["avatarfull"])),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  
                                ),
                              )
                              ],
                          )
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class _MainLinePainter extends CustomPainter {
  final double yCoordinate;
  _MainLinePainter({required this.yCoordinate}) {
    _paint = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }
  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(5, 0);
    path.lineTo(5, yCoordinate);
    path.conicTo(6, yCoordinate + 15, 30, yCoordinate + 15, 1);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
