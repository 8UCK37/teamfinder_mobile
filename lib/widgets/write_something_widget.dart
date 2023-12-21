import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/create_post_bottomsheet.dart';

import '../services/data_service.dart';

class WriteSomethingWidget extends StatelessWidget {
  const WriteSomethingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context);
    final userData = userService.user;
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 28.0,
                  child: ClipOval(
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/dp_placeholder.png'),
                      image: CachedNetworkImageProvider(
                        cacheKey:userService.profileImagecacheKey,
                        userData['profilePicture']??''),
                      width: 56.0,
                      height: 56.0,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        // Handle the error if needed
                        return Image.asset(
                          'assets/images/dp_placeholder.png',
                          width: 56.0,
                          height: 56.0,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 7.0),

                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    height: 50.0,
                    width: MediaQuery.of(context).size.width/1.4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Write something here...')),
                  ),
                  onTap: () {
                     Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CreatePost(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0,1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          //Divider(),

          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Icon(Icons.live_tv, size: 20.0, color: Colors.pink,),
          //           SizedBox(width: 5.0,),
          //           Text('Live', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16.0)),
          //         ],
          //       ),
          //       Container(height: 20, child: VerticalDivider(color: Colors.grey[600])),
          //       Row(
          //         children: <Widget>[
          //           Icon(Icons.photo_library, size: 20.0, color: Colors.green,),
          //           SizedBox(width: 5.0),
          //           Text('Photo', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16.0)),
          //         ],
          //       ),
          //       Container(height: 20, child: VerticalDivider(color: Colors.grey[600])),
          //       Row(
          //         children: <Widget>[
          //           Icon(Icons.video_call, size: 20.0, color: Colors.purple,),
          //           SizedBox(width: 5.0,),
          //           Text('Room', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16.0)),
          //         ],
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}