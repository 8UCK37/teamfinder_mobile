import 'package:flexi_chip/flexi_chip.dart';
import 'package:flutter/material.dart';

class ChipHelper extends StatefulWidget {
  const ChipHelper({super.key});

  @override
  State<ChipHelper> createState() => _ChipHelperState();
}


class _ChipHelperState extends State<ChipHelper> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void deleteLingo(dynamic s) {
    debugPrint(s as String);
  }

  List<Widget> buildFlexiChips() {
    List<Widget> chips = [];

    for (Language language in Language.values) {
      if (SelectedLanguage().languageMap[language]!) {
        chips.add(
          FlexiChip(
            label: Text(language.label),
            style: FlexiChipStyle.outlined(),
            checkmark: false,
            selected: SelectedLanguage().languageMap[language]!,
            onDeleted: () {
              deleteLingo(SelectedLanguage().languageMap[language].toString());
            },
          ),
        );
      } else {
        const SizedBox(height: 0, width: 0);
      }
    }
    if (chips.isEmpty) {
      return [const Text("No language preference has been set!!")];
    } else {
      return chips;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: buildFlexiChips(),
    );
  }
}

class SelectedLanguage {
  Map<Language, bool> languageMap = {
    Language.bengali: true,
    Language.english: true,
    Language.hindi: false,
  };

  // Method to return the language map
  Map<Language, bool> getList() {
    return languageMap;
  }
}

enum Language {
  bengali('Bengali', 1),
  hindi('Hindi', 2),
  english('English', 3);

  const Language(this.label, this.id);
  final String label;
  final int id;
}