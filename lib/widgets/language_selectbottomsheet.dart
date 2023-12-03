import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../utils/language_chip_helper.dart';

// ignore: must_be_immutable
class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  double heightMultiplier = .80;

  late Map<Language, bool> languageCheckboxes = {};
  late Map<Language, bool> langMapCopy =
      Map<Language, bool>.from(languageCheckboxes);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<Language, bool> languageSearch(
      String searchTerm, Map<Language, bool> inputMap) {
    Map<Language, bool> newMap = {};
    inputMap.forEach((key, value) {
      if (key.label.toLowerCase().contains(searchTerm)) {
        newMap[key] = inputMap[key]!;
      }
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    var modalHeight = MediaQuery.of(context).size.height * heightMultiplier;
    languageCheckboxes = userService.selectedLang;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: userService.darkTheme!
            ? const Color.fromRGBO(46, 46, 46, 1)
            : Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //border: Border.all(color: Colors.red),
      ),
      height: MediaQuery.of(context).size.height * heightMultiplier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                )
              ],
            ),
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: MediaQuery.of(context).size.width,
            height: modalHeight * 0.15,
            //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(
                      builder: (context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                          minHeight: 50),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            heightMultiplier = 0.95;
                          });
                        });
                      },
                      onChanged: (s) {
                        debugPrint(s);
                        setState(() {
                          langMapCopy = languageSearch(s, languageCheckboxes);
                        });
                      },
                      leading: const Icon(Icons.search),
                    );
                  }, suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  }),
                ),
              ],
            ),
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: MediaQuery.of(context).size.width,
            height: modalHeight * 0.10,
            //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ChipHelper()],
                ),
              ),
            ),
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: MediaQuery.of(context).size.width,
            height: modalHeight * 0.65,
            //decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
            child: ListView.builder(
              itemCount: langMapCopy.length,
              itemBuilder: (context, index) {
                Language language = langMapCopy.keys.toList()[index];
                return ListTile(
                  title: Text(language.label),
                  trailing: Checkbox(
                    value: userService.selectedLang[language] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        languageCheckboxes[language] = value!;
                        userService.updateSelectedLangMap(languageCheckboxes);
                        userService.updateSelectedLanguage();
                      });
                    },
                  ),
                  onTap: () {
                    // Toggle the checkbox state when the list tile is tapped
                    setState(() {
                      languageCheckboxes[language] =
                          !(languageCheckboxes[language] ?? false);
                      userService.updateSelectedLangMap(languageCheckboxes);
                      userService.updateSelectedLanguage();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
