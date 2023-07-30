import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';
import 'package:intl/intl.dart';

class FriendLinkedAcc extends StatefulWidget {
  const FriendLinkedAcc({super.key});

  @override
  State<FriendLinkedAcc> createState() => _FriendLinkedAccState();
}

class _FriendLinkedAccState extends State<FriendLinkedAcc> {
  dynamic steamData;
  dynamic twitchData;
  dynamic discordData;

  String decodeSteamTimeCreated(int steamTimeCreated) {
    List<String> monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    // Convert the Unix timestamp (in seconds) to milliseconds
    int steamTimeInMillis = steamTimeCreated * 1000;

    // Create a DateTime object from the milliseconds since epoch
    DateTime createdDateTime =
        DateTime.fromMillisecondsSinceEpoch(steamTimeInMillis);

    // Formatting the DateTime object to a human-readable string
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(createdDateTime);
    String onlyDate = formattedTime.split(" ")[0];
    String verboseDate =
        "${monthNames[int.parse(onlyDate.split("-")[1])]} ${onlyDate.split("-")[0]}";
    return verboseDate;
  }

  String formatTwitchDate(String dateTimeString) {
    List<String> monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    String formattedDateTime = dateTimeString.substring(0, 10);
    String verboseDate =
        "${monthNames[int.parse(formattedDateTime.split("-")[1])]} ${formattedDateTime.split("-")[0]}";
    return verboseDate;
  }

  int countNulls(dynamic var1, dynamic var2, dynamic var3) {
    int count = 0;

    if (var1 == null) count++;
    if (var2 == null) count++;
    if (var3 == null) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    steamData = profileService.steamData;
    twitchData = profileService.twitchData;
    discordData = profileService.discordData;
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 15,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 10),
                              child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(profileService
                                      .friendProfile!.profilePicture)),
                            ),
                            if (countNulls(steamData, discordData, twitchData) <
                                3)
                              CustomPaint(
                                willChange: true,
                                painter: _MainLinePainter(yCoordinate: 15),
                              ),
                            if (countNulls(steamData, discordData, twitchData) <
                                2)
                              CustomPaint(
                                willChange: true,
                                painter: _MainLinePainter(yCoordinate: 165),
                              ),
                            if (countNulls(
                                    steamData, discordData, twitchData) ==
                                0)
                              CustomPaint(
                                willChange: true,
                                painter: _MainLinePainter(yCoordinate: 310),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            countNulls(steamData, twitchData, discordData) != 3
                                ? "${profileService.friendProfile!.name}'s associated accounts"
                                : "${profileService.friendProfile!.name} currently has no account linked!!",
                            style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 58, top: 15, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                if (steamData != null)
                                  AccountCard(steamData, "steam"),
                                if (discordData != null)
                                  AccountCard(discordData, "discord"),
                                if (twitchData != null)
                                  AccountCard(twitchData, "twitch"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (countNulls(steamData, twitchData, discordData) == 3)
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/sad.png"),
                                  fit: BoxFit.fill)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    )
    );
  }

  // ignore: non_constant_identifier_names
  Widget AccountCard(dynamic data, String type) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    String logo = "";
    String brand = "";
    String avatar = "";
    String handle = "";
    String createdAt = "";
    if (type == "steam") {
      logo = "assets/images/steam_material.png";
      brand = "Steam";
      avatar = data["avatarfull"];
      handle = data["personaname"];
      createdAt = decodeSteamTimeCreated(steamData["timecreated"]);
    } else if (type == "discord") {
      logo = "assets/images/discord.png";
      brand = "Discord";
      avatar =
          "https://cdn.discordapp.com/avatars/${data["id"]}/${data["avatar"]}.png";
      handle = data["username"];
    } else if (type == "twitch") {
      logo = "assets/images/twitch.png";
      brand = "Twitch";
      avatar = data["profile_image_url"];
      handle = data["display_name"];
      createdAt = formatTwitchDate(data["created_at"]);
    }

    return Card(
      elevation: 20,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(logo),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        brand,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 32, 133, 216),
                            fontWeight: FontWeight.bold),
                      ),
                      if (type != "discord")
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("Joined on $createdAt"),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(avatar)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Platform handle:",
                    style: TextStyle(
                      color: userService.darkTheme!
                          ? Colors.amberAccent
                          : Colors.deepPurpleAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '"$handle"',
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          //width: 75,
                          height: 35,
                          decoration: BoxDecoration(
                              color: userService.darkTheme!
                                  ? const Color.fromRGBO(50, 38, 83, 1.0)
                                  : Color.fromARGB(255, 22, 224, 224),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Visit ${brand}Profile",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}

class _MainLinePainter extends CustomPainter {
  final double yCoordinate;
  _MainLinePainter({required this.yCoordinate}) {
    _paint = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
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
