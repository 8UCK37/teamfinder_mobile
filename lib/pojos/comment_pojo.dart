// To parse this JSON data, do
//
//     final commentPojo = commentPojoFromJson(jsonString);

import 'dart:convert';

import 'package:teamfinder_mobile/pojos/user_pojo.dart';

List<CommentPojo> commentPojoFromJson(String str) => List<CommentPojo>.from(
    json.decode(str).map((x) => CommentPojo.fromJson(x)));

String commentPojoToJson(List<CommentPojo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentPojo {
  int? id;
  DateTime? createdAt;
  String? commentStr;
  int? commentOf;
  int? postsId;
  String? userId;
  bool? deleted;
  UserPojo? author;
  List<dynamic>? commentReaction;
  dynamic reactionMap;
  dynamic userReaction;
  List<CommentPojo>? children;
  CommentPojo(
      {this.id,
      this.createdAt,
      this.commentStr,
      this.commentOf,
      this.postsId,
      this.userId,
      this.deleted,
      this.author,
      this.commentReaction,
      this.reactionMap,
      this.userReaction,
      this.children});

  factory CommentPojo.fromJson(Map<String, dynamic> json) => CommentPojo(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        commentStr: json["commentStr"],
        commentOf: json["commentOf"],
        postsId: json["postsId"],
        userId: json["userId"],
        deleted: json["deleted"],
        author:
            json["author"] == null ? null : UserPojo.fromJson(json["author"]),
        commentReaction: json["CommentReaction"] == null
            ? []
            : List<dynamic>.from(json["CommentReaction"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "commentStr": commentStr,
        "commentOf": commentOf,
        "postsId": postsId,
        "userId": userId,
        "deleted": deleted,
        "author": author?.toJson(),
        "CommentReaction": commentReaction == null
            ? []
            : List<dynamic>.from(commentReaction!.map((x) => x)),
      };
}
