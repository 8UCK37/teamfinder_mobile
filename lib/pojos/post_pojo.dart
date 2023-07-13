// To parse this JSON data, do
//
//     final postPojo = postPojoFromJson(jsonString);

import 'dart:convert';

List<PostPojo> postPojoFromJson(String str) => List<PostPojo>.from(json.decode(str).map((x) => PostPojo.fromJson(x)));

String postPojoToJson(List<PostPojo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostPojo {
    int id;
    String author;
    DateTime createdAt;
    String? description;
    String? photoUrl;
    bool deleted;
    Mention? mention;
    int? shared;
    String? raw;
    dynamic tagnames;
    String? name;
    String? profilePicture;
    dynamic reactiontype;
    bool? noreaction;
    String? likecount;
    String? hahacount;
    String? sadcount;
    String? lovecount;
    String? poopcount;
    PostPojo? parentpost;
    Parentpostauthor parentpostauthor;

    PostPojo({
        required this.id,
        required this.author,
        required this.createdAt,
        required this.description,
        required this.photoUrl,
        required this.deleted,
        required this.mention,
        required this.shared,
        required this.raw,
        required this.tagnames,
        required this.name,
        required this.profilePicture,
        required this.reactiontype,
        required this.noreaction,
        required this.likecount,
        required this.hahacount,
        required this.sadcount,
        required this.lovecount,
        required this.poopcount,
        required this.parentpost,
        required this.parentpostauthor,
    });

  factory PostPojo.fromJson(Map<String, dynamic> json) {
    final post = PostPojo(
    id: json["id"],
    author: json["author"],
    createdAt: DateTime.parse(json["createdAt"]),
    description: json["description"],
    photoUrl: json["photoUrl"],
    deleted: json["deleted"],
    mention: Mention.fromJson(json["mention"]),
    shared: json["shared"],
    raw: json["raw"],
    tagnames: json["tagnames"],
    name: json["name"],
    profilePicture: json["profilePicture"],
    reactiontype: json["reactiontype"],
    noreaction: json["noreaction"],
    likecount: json["likecount"],
    hahacount: json["hahacount"],
    sadcount: json["sadcount"],
    lovecount: json["lovecount"],
    poopcount: json["poopcount"],
    parentpost: json["parentpost"] != null ? PostPojo.fromJson(jsonDecode(json["parentpost"])) : null,
    parentpostauthor: Parentpostauthor.fromJson(json["parentpostauthor"]),
  );

  return post;
}

    Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "createdAt": createdAt.toIso8601String(),
        "description": description,
        "photoUrl": photoUrl,
        "deleted": deleted,
        "mention": mention?.toJson(),
        "shared": shared,
        "raw": raw,
        "tagnames": tagnames,
        "name": name,
        "profilePicture": profilePicture,
        "reactiontype": reactiontype,
        "noreaction": noreaction,
        "likecount": likecount,
        "hahacount": hahacount,
        "sadcount": sadcount,
        "lovecount": lovecount,
        "poopcount": poopcount,
        "parentpost": parentpost,
        "parentpostauthor": parentpostauthor.toJson(),
    };
}

class Mention {
    List<dynamic> list;

    Mention({
        required this.list,
    });

    factory Mention.fromJson(Map<String, dynamic> json) => Mention(
        list: List<dynamic>.from(json["list"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x)),
    };
}

class Parentpostauthor {
    String? name;
    String? profilePicture;

    Parentpostauthor({
        required this.name,
        required this.profilePicture,
    });

    factory Parentpostauthor.fromJson(Map<String, dynamic>? json) => Parentpostauthor(
        name: json?["name"],
        profilePicture: json?["profilePicture"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profilePicture": profilePicture,
    };
}
