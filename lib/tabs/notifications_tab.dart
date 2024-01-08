import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import '../pojos/incoming_notification.dart';
import '../services/data_service.dart';
import '../widgets/misc/notification_widget.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>
    with TickerProviderStateMixin {
  Future<void> _handleRefresh() async {}
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late int length;

  @override
  void initState() {
    final notiObserver =
        Provider.of<NotificationWizard>(context, listen: false);
    length = notiObserver.incomingNotificationList.length;
    super.initState();
  }

  void animateInsert() {
    final notiObserver =
        Provider.of<NotificationWizard>(context, listen: false);
    //debugPrint("init: $length");
    //debugPrint("changed: ${notiObserver.incomingNotificationList.length}");
    if (listKey.currentState != null) {
      if (length < notiObserver.incomingNotificationList.length) {
        length = notiObserver.incomingNotificationList.length;
        listKey.currentState!
            .insertItem(0, duration: const Duration(milliseconds: 150));
      }
    }
  }

  void removeItem(IncomingNotification noti, int index) {
    setState(() {
      length = length - 1;
    });
    //debugPrint("removed $index");
    //debugPrint("removal length $length");
    listKey.currentState!.removeItem(
        index,
        (context, animation) => NotificationWidget(
              notification: noti,
              animation: animation,
            ));
  }

  void removeAll() {
    final notiObserver =
        Provider.of<NotificationWizard>(context, listen: false);
    final userService = Provider.of<ProviderService>(context, listen: false);
    var notificationListCopy = notiObserver.incomingNotificationList;
    int count = notiObserver.incomingNotificationList.length-1;
    for (int i = count;
        i >= 0;
        i--) {
      listKey.currentState!.removeItem(
          i,
          duration: Duration(milliseconds: 150 + (i * 20)),
          (context, animation) => NotificationWidget(
                notification: notiObserver.incomingNotificationList[i],
                animation: animation,
              ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            notiObserver.updateNotiList(notificationListCopy);
          },
        ),
        content: const Text('All notification cleared!'),
      ),
    );
    int delay=0;
    for(int i=0;i<count;i++){
      delay=delay+(150+(i*20));
    }
    Future.delayed(Duration(milliseconds: delay), () {
      notiObserver.deleteAllNotification(userService.user['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    final userService = Provider.of<ProviderService>(context, listen: true);
    bool isDark = userService.darkTheme!;
    animateInsert();
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 25.0,
              elevation: 15,
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              title: Text(
                'Notifications',
                style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color.fromARGB(255, 31, 29, 29),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    removeAll();
                  },
                  icon: const Icon(Icons.clear_all),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (BuildContext context, int index) {
                  if (notiObserver.incomingNotificationList.isEmpty) {
                    // This is where the fixed header would be
                    length = 0;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 190,
                      width: double.infinity,
                      child: const Text(
                        'All caught up for now!!',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.transparent)),
                      height: MediaQuery.of(context).size.height - 185,
                      child: AnimatedList(
                        key: listKey,
                        initialItemCount:
                            notiObserver.incomingNotificationList.length,
                        itemBuilder: (BuildContext context, int index,
                            Animation<double> animation) {
                          IncomingNotification notification = notiObserver
                              .incomingNotificationList.reversed
                              .toList()[index];
                          return NotificationWidget(
                            notification: notification,
                            animation: animation,
                            removeClicked: () =>
                                removeItem(notification, index),
                          );
                        },
                      ),
                    );
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
