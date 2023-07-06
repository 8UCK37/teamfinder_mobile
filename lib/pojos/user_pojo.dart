import 'package:meta/meta.dart';
import 'dart:convert';

List<UserPojo> userPojoFromJson(String str) => List<UserPojo>.from(json.decode(str).map((x) => UserPojo.fromJson(x)));

String userPojoToJson(List<UserPojo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPojo {
    String id;
    DateTime createdAt;
    String name;
    String profilePicture;
    String? steamId;
    String gmailId;
    bool activeChoice;
    bool isConnected;
    String profileBanner;
    dynamic bio;
    int? userInfoId;
    String chatBackground;
    int themesId;

    UserPojo({
        required this.id,
        required this.createdAt,
        required this.name,
        required this.profilePicture,
        this.steamId,
        required this.gmailId,
        required this.activeChoice,
        required this.isConnected,
        required this.profileBanner,
        this.bio,
        this.userInfoId,
        required this.chatBackground,
        required this.themesId,
    });

    factory UserPojo.fromJson(Map<String, dynamic> json) => UserPojo(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        name: json["name"],
        profilePicture: json["profilePicture"],
        steamId: json["steamId"],
        gmailId: json["gmailId"],
        activeChoice: json["activeChoice"],
        isConnected: json["isConnected"],
        profileBanner: json["profileBanner"],
        bio: json["bio"] ?? 'null',
        userInfoId: json["userInfoId"],
        chatBackground: json["chatBackground"],
        themesId: json["themesId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "name": name,
        "profilePicture": profilePicture,
        "steamId": steamId,
        "gmailId": gmailId,
        "activeChoice": activeChoice,
        "isConnected": isConnected,
        "profileBanner": profileBanner,
        "bio": bio,
        "userInfoId": userInfoId,
        "chatBackground": chatBackground,
        "themesId": themesId,
    };
}
