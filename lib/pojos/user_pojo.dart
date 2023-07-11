import 'dart:convert';

List<UserPojo> userPojoListFromJson(String str) =>
    List<UserPojo>.from(json.decode(str).map((x) => UserPojo.fromJson(x)));

String userPojoListToJson(List<UserPojo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  UserInfo? userInfo;
  Theme? theme;
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
    this.userInfo,
    this.theme,
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
        userInfo: UserInfo.fromJson(json["userInfo"]),
        theme: Theme.fromJson(json["theme"])
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
        "userInfo": userInfo!.toJson(),
        "theme": theme!.toJson()
      };
}
class Theme {
    int? id;
    String? createdAt;
    String? name;
    String? navBg;
    String? homeBg;
    String? profileBg;
    dynamic accentColor;
    String? compColor;

    Theme({
         this.id,
         this.createdAt,
         this.name,
         this.navBg,
         this.homeBg,
         this.profileBg,
         this.accentColor,
         this.compColor,
    });

    factory Theme.fromJson(Map<String, dynamic>? json) => Theme(
        id: json?["id"],
        createdAt: json?["createdAt"],
        name: json?["name"],
        navBg: json?["navBg"],
        homeBg: json?["homeBg"],
        profileBg: json?["profileBg"],
        accentColor: json?["accentColor"],
        compColor: json?["compColor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "name": name,
        "navBg": navBg,
        "homeBg": homeBg,
        "profileBg": profileBg,
        "accentColor": accentColor,
        "compColor": compColor,
    };
}
class UserInfo {
    int? id;
    String? createdAt;
    String? gender;
    String? country;
    String? language;
    String? address;

    UserInfo({
         this.id,
         this.createdAt,
         this.gender,
         this.country,
         this.language,
         this.address,
    });

    factory UserInfo.fromJson(Map<String, dynamic>? json) => UserInfo(
        id: json?["id"],
        createdAt: json?["createdAt"],
        gender: json?["Gender"],
        country: json?["Country"],
        language: json?["Language"],
        address: json?["Address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "Gender": gender,
        "Country": country,
        "Language": language,
        "Address": address,
    };
}