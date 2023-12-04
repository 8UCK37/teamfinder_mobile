import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import '../widgets/notification_widget.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _NotificationsTabState createState() => _NotificationsTabState();
  }

class _NotificationsTabState extends State<NotificationsTab> with TickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
              child: Text('Notifications', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            ),

            for(IncomingNotification notification in notiObserver.incomingNotificationList) 
                NotificationWidget(notification: notification)
          ],
        )
      ),
    );
  }
  
}