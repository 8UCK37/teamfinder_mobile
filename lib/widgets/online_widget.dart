import 'package:flutter/material.dart';

class  OnlineWidget extends StatelessWidget {
  const OnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 15.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                width: 1.0,
                color: Colors.blue
              )
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.video_call, size: 20, color: Colors.purple),
                SizedBox(width: 5.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Post', style: TextStyle(color: Colors.blue)),
                    Text('Video', style: TextStyle(color: Colors.blue)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),

          const Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                backgroundImage: AssetImage(''),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15.0),
        ],
      ),
    );
  }
}