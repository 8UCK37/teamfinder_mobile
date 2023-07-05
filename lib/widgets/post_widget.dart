import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';

import '../models/post.dart';

class PostWidget extends StatelessWidget {

  final PostPojo post;

  PostWidget({
    required this.post
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(post.profilePicture),
                radius: 20.0,
              ),
              const SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                  const SizedBox(height: 5.0),
                  Text(post.author)
                ],
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          Text(post.description, style: const TextStyle(fontSize: 15.0)),

          const SizedBox(height: 10.0),
          Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(post.photoUrl), fit: BoxFit.cover),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.blue),
                  Text(' ${post.likecount}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('${post.hahacount} comments  •  '), //TODO:need to assign real values
                  Text('${post.lovecount} shares'),
                ],
              ),
            ],
          ),

          const Divider(height: 30.0),

          const Row(
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
          )
        ],
      ),
    );
  }
}