import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mock_data/mock_data.dart';
import 'package:simply_mentions/text/mention_text_editing_controller.dart';
import 'package:teamfinder_mobile/widgets/simplyMention/types/mentions.dart';

import '../../pojos/user_pojo.dart';

List<MentionObject> documentMentions = [];

class SimplyMentionInterface extends StatefulWidget {
  const SimplyMentionInterface({super.key});

  @override
  State<SimplyMentionInterface> createState() => _SimplyMentionInterfaceState();
}

class _SimplyMentionInterfaceState extends State<SimplyMentionInterface> {
  MentionTextEditingController? mentionTextEditingController;
  FocusNode focusNode = FocusNode();

  late List<UserPojo> userList = [];

  @override
  void initState() {
    //mockDataInit();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mentionTextEditingController == null) {
      // Create a mention text editing controller and pass in the relevant syntax, then bind to onSuggestionChanged
      mentionTextEditingController = MentionTextEditingController(
          mentionSyntaxes: [DocumentMentionEditableSyntax(context)],
          mentionBgColor: Colors.white,
          mentionTextColor: Colors.blue,
          runTextStyle: const TextStyle(color: Colors.black),
          mentionTextStyle: const TextStyle(),
          onSugggestionChanged: onSuggestionChanged,
          idToMentionObject: (BuildContext context, String id) =>
              documentMentions.firstWhere((element) => element.id == id));

      /// Set markup text, any text that is the raw text that will be saved

      // mentionTextEditingController!.setMarkupText(
      //     context, "Hello <###@ExampleId###>, how are you doing?");

      mentionTextEditingController!.addListener(() {
        setState(() {});
        if (mentionTextEditingController!.isMentioning()) {
          //debugPrint("search term:${mentionTextEditingController!.getSearchText()}");
          String safeSearch = removeDiacritics(mentionTextEditingController!.getSearchText());
          searchUser(safeSearch);
        }
      });
    }

    focusNode.requestFocus();
  }

  void mockDataInit() {
    //TODO: remove this

    // documentMentions.add(MentionObject(
    //     id: "ExampleId",
    //     displayName: "Jane Doe",
    //     avatarUrl: "https://placekitten.com/50/50"));

    // Generate 100 random mentions
    for (int i = 0; i < 100; ++i) {
      documentMentions.add(MentionObject(
          id: mockUUID(),
          displayName: "${mockName()} ${mockName()}",
          avatarUrl: "https://placekitten.com/50/50"));
    }
  }

  void onSuggestionChanged(MentionSyntax? syntax, String? fullSearchString) {
    setState(() {});
  }

  // When a mention is selected, insert the mention into the text editing controller.
  // This will insert a mention in the current mentioning text, will assert if not currently mentioning
  void onMentionSelected(MentionObject mention) {
    setState(() {
      mentionTextEditingController!.insertMention(mention);
    });
    debugPrint(mention.toString());
  }

  void searchUser(String userInp) async {
    //debugPrint("called");
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    //ignore: prefer_is_empty
    if (userInp.length == 0) {
      setState(() {
        userList = [];
      });
      return;
    }
    //debugPrint('from search userinp: $userInp');
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/searchFriend',
      data: {'searchTerm': userInp},
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint('user data searched');
      //debugPrint(response.data);
      setState(() {
        userList = userPojoListFromJson(response.data)
            .where((userPojo) => userPojo.id != user.uid)
            .toList();

        parseSearchResultIntoPossibleMentionList(userList);
      });
    }
  }

  void parseSearchResultIntoPossibleMentionList(List<UserPojo> searchResult) {
    if (searchResult.isEmpty) {
      return;
    }
    setState(() {
      documentMentions = [];
    });
    for (var element in searchResult) {
      documentMentions.add(MentionObject(
          id: element.id,
          displayName: element.name,
          avatarUrl: element.profilePicture));
    }
  }

  // Create any widget of your choosing to make a list of possible mentions using the search string
  Widget buildMentionSuggestions() {
    if (!mentionTextEditingController!.isMentioning()) {
      return const SizedBox.shrink();
    }

    List<Widget> possibleMentions = [];

    // Remove diacritics and lowercase the search string so matches are easier found

    documentMentions.forEach((element) {
      possibleMentions.add(Container(
        child: ListTile(
          leading: CircleAvatar(
            maxRadius: 25,
            backgroundImage: NetworkImage(element.avatarUrl),
          ),
          title: Text(
            element.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            //Tell the mention controller to insert the mention
            onMentionSelected(element);
          },
        ),
      ));
    });
    ScrollController controller = ScrollController();

    return Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(67, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        child: Scrollbar(
            controller: controller,
            child: ListView.separated(
              controller: controller,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: possibleMentions.length,
              separatorBuilder: (context, i) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return possibleMentions[index];
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
        visible: mentionTextEditingController!.isMentioning(),
        portalFollower:buildMentionSuggestions(),
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
          widthFactor: 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: "Type away..."),
            focusNode: focusNode,
            maxLines: null,
            minLines: 3,
            controller: mentionTextEditingController,
          ),
        ));
  }
}
