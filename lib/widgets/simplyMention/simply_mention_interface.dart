import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:simply_mentions/text/mention_text_editing_controller.dart';
import 'package:teamfinder_mobile/widgets/simplyMention/types/mentions.dart';


import '../../services/data_service.dart';
import '../../services/mention_service.dart';

List<MentionObject> documentMentions = [];

class SimplyMentionInterface extends StatefulWidget {
  final FocusNode focusNode;
  final String? markUptext;
  final List<MentionObject> mentionableList;
  const SimplyMentionInterface({
    super.key,
    required this.focusNode,
    this.markUptext,
    required this.mentionableList,
  });

  @override
  State<SimplyMentionInterface> createState() => _SimplyMentionInterfaceState();
}

class _SimplyMentionInterfaceState extends State<SimplyMentionInterface> {

  MentionTextEditingController? mentionTextEditingController;
  late FocusNode focusNode = widget.focusNode;
  late bool isDark;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userService = Provider.of<ProviderService>(context, listen: false);
    setState(() {
      isDark = userService.darkTheme!;
    });

    if (mentionTextEditingController == null) {

      documentMentions = widget.mentionableList;

      // Create a mention text editing controller and pass in the relevant syntax, then bind to onSuggestionChanged
      mentionTextEditingController = MentionTextEditingController(
          mentionSyntaxes: [DocumentMentionEditableSyntax(context)],
          mentionBgColor: Colors.transparent,
          mentionTextColor: Colors.blue,
          runTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
          mentionTextStyle: const TextStyle(),
          onSugggestionChanged: onSuggestionChanged,
          idToMentionObject: (BuildContext context, String id) =>
              documentMentions.firstWhere((element) => element.id == id));

      /// Set markup text, any text that is the raw text that will be saved
      if (widget.markUptext != null) {
        ///<###@ExampleId###>
        mentionTextEditingController!
            .setMarkupText(context, widget.markUptext!);
      }

      mentionTextEditingController!.addListener(() {
        final mentionService =
            Provider.of<MentionService>(context, listen: false);
        mentionService
            .updateMarkUpText(mentionTextEditingController!.getMarkupText());

        setState(() {});
      });
    }

    //focusNode.requestFocus();
  }

  void onSuggestionChanged(MentionSyntax? syntax, String? fullSearchString) {
    setState(() {});
  }

  // When a mention is selected, insert the mention into the text editing controller.
  // This will insert a mention in the current mentioning text, will assert if not currently mentioning
  void onMentionSelected(MentionObject mention) {
    final mentionService = Provider.of<MentionService>(context, listen: false);
    setState(() {
      mentionTextEditingController!.insertMention(mention);
    });
    debugPrint(mention.toString());
    mentionService.appendToMentionRepo(mention);
  }

  // Create any widget of your choosing to make a list of possible mentions using the search string
  Widget buildMentionSuggestions() {
    if (!mentionTextEditingController!.isMentioning()) {
      return const SizedBox.shrink();
    }
    // final notiObserver = Provider.of<NotificationWizard>(context, listen: true);
    // List<MentionObject> mentionAbleList = notiObserver.mentionAbleList;
    List<Widget> possibleMentions = [];
    // Remove diacritics and lowercase the search string so matches are easier found
    String safeSearch =
        removeDiacritics(mentionTextEditingController!.getSearchText());

    for (MentionObject element in documentMentions) {
      String safeName = removeDiacritics(element.displayName.toLowerCase());
      if (safeSearch.isNotEmpty && safeName.contains(safeSearch)) {
        possibleMentions.add(
          ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(element.avatarUrl),
            ),
            title: Text(
              element.displayName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              //Tell the mention controller to insert the mention
              onMentionSelected(element);
            },
          ),
        );
      }
    }

    ScrollController controller = ScrollController();

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(197, 255, 255, 255),
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
        portalFollower: buildMentionSuggestions(),
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
          widthFactor: 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLength: 1000,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gapPadding: 5),
                contentPadding: EdgeInsets.all(8),
                hintText: "Type away..."),
            cursorColor:
                isDark ? Colors.white : const Color.fromARGB(255, 12, 11, 11),
            focusNode: focusNode,
            maxLines: null,
            minLines: 5,
            controller: mentionTextEditingController,
          ),
        ));
  }
}
