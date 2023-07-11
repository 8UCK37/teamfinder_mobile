
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../services/user_service.dart';
import '../widgets/separator_widget.dart';
import '../widgets/write_something_widget.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userData = userService.user;
    return Column(
      children:<Widget> [
        Expanded(child: 
        SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 360.0,
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                imageUrl: userData['profileBanner'],
                imageBuilder: (context, imageProvider) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(userData['profileBanner']), fit: BoxFit.cover),
                    borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  ),
                ),
                 placeholder: (contex, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0.0),
                                height: 200.0,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                errorWidget: (context,url,error)=>Image.asset('assets/images/error-404.png')
                ),
                const SizedBox(height: 20.0),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0,top: 25),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['profilePicture']),
                        radius: 50.0,
                      ),
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(userData['name'], style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: WriteSomethingWidget(),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Divider(height: 40.0),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(Icons.home, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('Lives in New York', style: TextStyle(fontSize: 16.0))
                  ],
                ),
                const SizedBox(height: 15.0),
                const Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('From New York', style: TextStyle(fontSize: 16.0))
                  ],
                ),
                const SizedBox(height: 15.0),
                const Row(
                  children: <Widget>[
                    Icon(Icons.more_horiz, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('See your About Info', style: TextStyle(fontSize: 16.0))
                  ],
                ),

                const SizedBox(height: 15.0),

                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(child: Text('Edit Public Details', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0))),
                ),
              ],
            ),
          ),

          const Divider(height: 40.0),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Friends', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6.0),
                        Text('536 friends', style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                      ],
                    ),
                    const Text('Find Friends', style: TextStyle(fontSize: 16.0, color: Colors.blue)),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage('')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Samantha', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage('')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Andrew', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage(''), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Sam Wilson', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage('')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Steven', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage('')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Greg', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: const DecorationImage(image: AssetImage(''), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Andy', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(child: Text('See All Friends', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0))),
                ),
              ],
            ),
          ),
          SeparatorWidget(),
          ],
      )
      ),
    ),
    const GNav(
      gap:8,
      tabs: [
          GButton(
            icon: Icons.receipt_long,
            text: 'Posts',
            textColor: Colors.deepPurple,
          ),
          GButton(
            icon: Icons.sports_esports,
            text: 'Games',
            textColor: Colors.deepOrange,
          ),
          GButton(
            icon: Icons.link,
            text: 'Linked Acc',
            textColor: Colors.blue,
          ),
        ]),
    ],
    )
    ;
  }
}