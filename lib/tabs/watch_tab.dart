
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/misc/separator_widget.dart';

class WatchTab extends StatefulWidget {
  @override
  _WatchTabState createState() => _WatchTabState();
}

class _WatchTabState extends State<WatchTab> {
  String videoUrl1 = 'https://www.youtube.com/watch?v=j5-yKhDd64s';
  late YoutubePlayerController _controller1;

  String videoUrl2 = 'https://www.youtube.com/watch?v=E1ZVSFfCk9g';
  late YoutubePlayerController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = YoutubePlayerController(initialVideoId: 'j5-yKhDd64s');
    _controller2 = YoutubePlayerController(initialVideoId: 'E1ZVSFfCk9g');
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                child: Text('Watch', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              ),

              Container(
                height: 60.0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const SizedBox(width: 15.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.videocam, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Live', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),

                    const SizedBox(width: 10.0),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.music_note, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Music', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),      

                    const SizedBox(width: 10.0),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.check_box, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Following', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ), 

                    const SizedBox(width: 10.0),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.fastfood, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Food', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ), 

                    const SizedBox(width: 10.0),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.grey[300]
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.gamepad, size: 20.0),
                          SizedBox(width: 5.0),
                          Text('Gaming', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ), 

                    const SizedBox(width: 15.0),         
                  ],
                ),
              ),

              SeparatorWidget(),

              Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/greg.jpg'),
                          radius: 20.0,
                        ),
                        SizedBox(width: 7.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Greg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                            SizedBox(height: 5.0),
                            Text('7h')
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  YoutubePlayer(controller: _controller1),

                  const SizedBox(height: 10.0),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.blue),
                            Text(' 23'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('2 comments  •  '),
                            Text('1 share'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(height: 30.0),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Like', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Comment', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.share, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Share', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20.0),

              SeparatorWidget(),

              Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/olivia.jpg'),
                          radius: 20.0,
                        ),
                        SizedBox(width: 7.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Olivia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                            SizedBox(height: 5.0),
                            Text('10h')
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  YoutubePlayer(controller: _controller2),

                  const SizedBox(height: 10.0),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.blue),
                            Text(' 98'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('12 comments  •  '),
                            Text('6 shares'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(height: 30.0),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Like', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Comment', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.share, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Share', style: TextStyle(fontSize: 14.0)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20.0),

              SeparatorWidget(),
            ],
          )
        ),
      ),
    );
  }
}