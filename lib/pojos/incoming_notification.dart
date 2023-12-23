import 'package:hive/hive.dart';
part 'incoming_notification.g.dart';
@HiveType(typeId: 1,adapterName: "NotificationAdapter")

class IncomingNotification extends HiveObject {
  @HiveField(0)
  final String senderId;
  @HiveField(1)
  final String senderProfilePicture;
  @HiveField(2)
  final String senderName;
  @HiveField(3)
  final String notification;
  @HiveField(4)
  final dynamic data;
  @HiveField(5)
  final String timeStamp;

  IncomingNotification(
      {required this.senderId,
      required this.senderProfilePicture,
      required this.senderName,
      required this.notification,
      required this.data,
      required this.timeStamp});
}

