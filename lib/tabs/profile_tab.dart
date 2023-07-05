
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart';
import '../widgets/separator_widget.dart';
import '../widgets/write_something_widget.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userData = userService.user;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 360.0,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(userData['profileBanner']), fit: BoxFit.cover),
                    borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  ),
                ),
                SizedBox(height: 20.0),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0,top: 25),
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
                    Text(userData['name'], style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Divider(height: 40.0),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.home, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('Lives in New York', style: TextStyle(fontSize: 16.0))
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('From New York', style: TextStyle(fontSize: 16.0))
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Icon(Icons.more_horiz, color: Colors.grey, size: 30.0),
                    SizedBox(width: 10.0),
                    Text('See your About Info', style: TextStyle(fontSize: 16.0))
                  ],
                ),

                SizedBox(height: 15.0),

                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(child: Text('Edit Public Details', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0))),
                ),
              ],
            ),
          ),

          Divider(height: 40.0),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Friends', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6.0),
                        Text('536 friends', style: TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                      ],
                    ),
                    Text('Find Friends', style: TextStyle(fontSize: 16.0, color: Colors.blue)),
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
                              image: DecorationImage(image: AssetImage('assets/samantha.jpg')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Samantha', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/andrew.jpg')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Andrew', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/Sam Wilson.jpg'), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Sam Wilson', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
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
                              image: DecorationImage(image: AssetImage('assets/steven.jpg')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Steven', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/greg.jpg')),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Greg', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width/3 -20 ,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/andy.jpg'), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Andy', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(child: Text('See All Friends', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0))),
                ),
              ],
            ),
          ),
          SeparatorWidget()
        ],
      )
    );
  }
}