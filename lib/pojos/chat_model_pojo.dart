import 'package:meta/meta.dart';
import 'dart:convert';

List<ChatModelPojo> chatModelPojoFromJson(String str) => List<ChatModelPojo>.from(json.decode(str).map((x) => ChatModelPojo.fromJson(x)));

String chatModelPojoToJson(List<ChatModelPojo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModelPojo {
    String msg;
    String photoUrl;
    bool rec;
    String sender;
    String time;

    ChatModelPojo({
        required this.msg,
        required this.photoUrl,
        required this.rec,
        required this.sender,
        required this.time,
    });

    factory ChatModelPojo.fromJson(Map<String, dynamic> json) => ChatModelPojo(
        msg: json["msg"],
        photoUrl: json["photoUrl"],
        rec: json["rec"],
        sender: json["sender"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "photoUrl": photoUrl,
        "rec": rec,
        "sender": sender,
        "time": time,
    };
}
