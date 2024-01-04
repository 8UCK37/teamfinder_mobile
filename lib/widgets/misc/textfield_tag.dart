import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../services/mention_service.dart';
import '../../utils/theme.dart';

class TextFieldTagInterface extends StatefulWidget {
  final bool? showHelperText;
  const TextFieldTagInterface({super.key, this.showHelperText});

  @override
  State<TextFieldTagInterface> createState() => _TextFieldTagInterfaceState();
}

class _TextFieldTagInterfaceState extends State<TextFieldTagInterface> {
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;

    _controller.addListener(() {
      if (_controller.hasTags) {
        final mentionService =
            Provider.of<MentionService>(context, listen: false);
        mentionService.updateTagList(_controller.getTags!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  static const List<String> _pickTopic = <String>[
    'Fortnite',
    'Minecraft',
    'Call of Duty: Warzone',
    'Call of Duty: Black Ops Cold War',
    'Counter Strike 2',
    'RDR2',
    'Red Dead Redemption',
    'Sea of Thieves',
    'Among Us',
    'Fall Guys: Ultimate Knockout',
    'Cyberpunk 2077',
    'The Witcher 3: Wild Hunt',
    'Valorant',
    'League of Legends',
    'Apex Legends',
    'Titanfall 2',
    "Assassin's Creed Valhalla",
    "Assassin's Creed Odyssey",
    'Animal Crossing: New Horizons',
    'The Legend of Zelda: Breath of the Wild',
    'FIFA 21',
    'NBA 2K21',
    'Overwatch',
    'World of Warcraft: Shadowlands'
        'Valorant'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Autocomplete<String>(
          optionsViewBuilder: (context, onSelected, options) {
            return Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(212, 255, 255, 255),
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              margin:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, i) {
                  return const Divider();
                },
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final dynamic option = options.elementAt(index);
                  return TextButton(
                    onPressed: () {
                      onSelected(option);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          '#$option',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _pickTopic.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selectedTag) {
            _controller.addTag = selectedTag;
          },
          fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
            return TextFieldTags(
              textEditingController: ttec,
              focusNode: tfn,
              textfieldTagsController: _controller,
              initialTags: const [],
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (tag == 'php') {
                  return 'No, please just no';
                } else if (_controller.getTags!.contains(tag)) {
                  return 'you already entered that';
                }
                return null;
              },
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        helperText: widget.showHelperText!=false? "Specify tags to set the topic of this post...":null,
                        helperStyle: TextStyle(color: ThemeColor.primaryTheme),
                        hintText: _controller.hasTags ? '' : "Enter tags...",
                        hintStyle: const TextStyle(color: Colors.blue),
                        errorText: error,
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: _distanceToField * .90),
                        prefixIcon: tags.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color: Colors.blue,
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                //print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()),
                                ),
                              )
                            : null,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}
