import 'package:flexi_chip/flexi_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

// ignore: must_be_immutable
class ChipHelper extends StatefulWidget {
  const ChipHelper({super.key});

  @override
  State<ChipHelper> createState() => _ChipHelperState();
}

class _ChipHelperState extends State<ChipHelper> {
  var selectedLangList = [];

  @override
  void initState() {
    super.initState();
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.getUserSelectedLang();
  }

  @override
  void dispose() {
    super.dispose();
  }


  List<Widget> buildFlexiChips(Map<Language, bool> map) {
    List<Widget> chips = [];
    final userService = Provider.of<ProviderService>(context, listen: true);
    for (Language language in Language.values) {
      if (map[language]!) {
        chips.add(
          FlexiChip(
            label: Text(language.label),
            style: FlexiChipStyle.outlined(color: userService.darkTheme!? Colors.white:Colors.deepPurple,),
            checkmark: false,
            selected: map[language]!,
            onDeleted: () {
              setState(() {
                map[language] = false;
                userService.updateSelectedLangMap(map);
                userService.updateSelectedLanguage();
              });
            },
          ),
        );
      } else {
        const SizedBox(height: 0, width: 0);
      }
    }
    if (chips.isEmpty) {
      return [
        GestureDetector(
            onTap: () {
              debugPrint("test");

              userService.selectedLang.forEach((key, value) {
                debugPrint('for $key value= $value');
              });
            },
            child: const Text("No language preference has been set!!"))
      ];
    } else {
      return chips;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Wrap(
      spacing: 10,
      children: buildFlexiChips(userService.selectedLang),
    );
  }
}

enum Language {
  arabic('Arabic', 1),
  bengali('Bengali', 2),
  chineseMandarin('Chinese (Mandarin)', 3),
  english('English', 4),
  french('French', 5),
  german('German', 6),
  gujarati('Gujarati', 7),
  hausa('Hausa', 8),
  hindi('Hindi', 9),
  italian('Italian', 10),
  japanese('Japanese', 11),
  javanese('Javanese', 12),
  kannada('Kannada', 13),
  korean('Korean', 14),
  malayalam('Malayalam', 15),
  marathi('Marathi', 16),
  oriya('Oriya', 17),
  portuguese('Portuguese', 18),
  punjabi('Punjabi', 19),
  russian('Russian', 20),
  spanish('Spanish', 21),
  swahili('Swahili', 22),
  tamil('Tamil', 23),
  telugu('Telugu', 24),
  urdu('Urdu', 25),
  turkish('Turkish', 26);

  const Language(this.label, this.id);
  final String label;
  final int id;

  static Map<Language, bool> map() {
    Map<Language, bool> langMap = {};
    for (Language lang in Language.values) {
      langMap[lang] = false;
    }
    return langMap;
  }
}
