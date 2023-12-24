import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import '../pojos/incoming_notification.dart';
import '../widgets/notification_widget.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>
    with TickerProviderStateMixin {
  Future<void> _handleRefresh() async {}

  @override
  Widget build(BuildContext context) {
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 25.0,
              elevation: 15,
              floating: false,
              pinned: true,
              title: const Text(
                'Notifications',
                style: TextStyle(
                    color: Color.fromARGB(255, 31, 29, 29),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    notiObserver.deleteAllNotification();
                  },
                  icon: const Icon(Icons.clear_all),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: notiObserver.incomingNotificationList.length,
                (BuildContext context, int index) {
                  if (notiObserver.incomingNotificationList.isEmpty) {
                    // This is where the fixed header would be
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 190,
                      width: double.infinity,
                      child: const Text(
                        'All caught up for now!!',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    // This is where your scrollable content would be
                    IncomingNotification notification = notiObserver.incomingNotificationList.reversed.toList()[index];
                    return NotificationWidget(notification: notification);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
