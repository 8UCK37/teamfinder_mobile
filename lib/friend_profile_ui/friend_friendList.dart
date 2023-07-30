import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';

class FriendsFriendList extends StatefulWidget {
  const FriendsFriendList({super.key});

  @override
  State<FriendsFriendList> createState() => _FriendsFriendListState();
}

class _FriendsFriendListState extends State<FriendsFriendList> {
  List<UserPojo>? friendList;
  @override
  Widget build(BuildContext context) {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    friendList = profileService.friendList;
    // ignore: prefer_const_constructors
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              elevation: 20,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                decoration: const BoxDecoration(
                    //border: Border.all(color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomGrid(items: friendList),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}

// ignore: must_be_immutable
class CustomGrid extends StatelessWidget {
  dynamic items;
  CustomGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of cards in a row
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        if (items != null) {
          return CustomCard(friend: items[index]);
        }
        return null;
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final dynamic friend;

  const CustomCard({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 10,
    );
  }
}
