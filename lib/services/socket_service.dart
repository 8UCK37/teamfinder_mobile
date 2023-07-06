import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  IO.Socket? socket;
  final BehaviorSubject<Map<String, dynamic>> _incomingMsgSubject =
      BehaviorSubject<Map<String, dynamic>>();
  final BehaviorSubject<Map<String, dynamic>> _incomingNotiSubject =
      BehaviorSubject<Map<String, dynamic>>();

  void setupSocketConnection() {
    socket = IO.io(dotenv.env['socket_endpoint'], <String, dynamic>{
      'transports': ['websocket'],
    });

    socket?.on('my broadcast', (data) {
      // incoming msg
      // print('inc msg from services: $data');
      _incomingMsgSubject.add(data);
    });

    socket?.on('notification', (data) {
      print('incoming notification');
      print(data);
      if (data is Map<String, dynamic>) {
        _incomingNotiSubject.add(data);
      } else if (data is String) {
        _incomingNotiSubject.add({"data": data});
      } else {
        _incomingNotiSubject.add({});
      }
    });
  }

  void setSocketId(dynamic id) {
    final data = {'name': id};
    socket?.emit('setSocketId', data);
  }

  void disconnect() {
    socket?.disconnect();
  }

  void send(dynamic msg) {
    print('sending this msg: $msg');
    socket?.emit('my message', msg);
  }

  void sendNoti(dynamic noti) {
    print('sending this noti: $noti');
    socket?.emit('notification', noti);
  }

  ValueStream<Map<String, dynamic>> getIncomingMsg() {
    return _incomingMsgSubject.stream;
  }

  ValueStream<Map<String, dynamic>> getIncomingNoti() {
    return _incomingNotiSubject.stream;
  }
}
