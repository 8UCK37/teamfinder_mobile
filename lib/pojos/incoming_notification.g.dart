// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationAdapter extends TypeAdapter<IncomingNotification> {
  @override
  final int typeId = 1;

  @override
  IncomingNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomingNotification(
      senderId: fields[0] as String,
      senderProfilePicture: fields[1] as String,
      senderName: fields[2] as String,
      notification: fields[3] as String,
      data: fields[4] as dynamic,
      timeStamp: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IncomingNotification obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.senderProfilePicture)
      ..writeByte(2)
      ..write(obj.senderName)
      ..writeByte(3)
      ..write(obj.notification)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
