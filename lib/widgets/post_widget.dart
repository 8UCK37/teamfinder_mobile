import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';

class PostWidget extends StatelessWidget {

  final PostPojo post;

  PostWidget({
    required this.post
  });
  String convertToLocalTime(DateTime dateTime) {
    
    DateTime localDateTime = dateTime.toLocal();
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
    //var splicedTime = formattedTime.split(" ")[1].split(":");

    return formattedTime.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(post.profilePicture!),
                radius: 20.0,
              ),
              const SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(post.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                  const SizedBox(height: 5.0),
                  Text(convertToLocalTime(post.createdAt))
                ],
              ),
            ],
          ),

          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(post.description!, style: const TextStyle(fontSize: 15.0)),
          ),
          const SizedBox(height: 5.0),
          CachedNetworkImage(
            imageUrl: (post.shared==null)? post.photoUrl!:post.parentpost!.photoUrl!,
            placeholder:(contex,url)=> Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.white,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            errorWidget: (context,url,error)=>Image.asset('assets/images/error-404.png'),
            imageBuilder: (context, imageProvider) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage((post.shared==null)? post.photoUrl!:post.parentpost!.photoUrl!), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(6),
              ),
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