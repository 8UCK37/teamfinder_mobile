import 'package:flutter/material.dart';

class ColorSplash {
  Color circleColorStart;
  Color circleColorEnd;
  Color dotPrimaryColor;
  Color dotSecondaryColor;

  ColorSplash({
    required this.circleColorStart,
    required this.circleColorEnd,
    required this.dotPrimaryColor,
    required this.dotSecondaryColor,
  });

  static ColorSplash getColorPalette(int type) {
    switch (type) {
      case 0:
        return ColorSplash(
          circleColorStart: const Color.fromRGBO(242, 151, 39, 100),
          circleColorEnd: const Color.fromRGBO(242, 76, 61, 100),
          dotPrimaryColor: const Color.fromRGBO(242, 151, 39, 100),
          dotSecondaryColor: const Color.fromRGBO(242, 76, 61, 100),
        );
      case 1:
        return ColorSplash(
          circleColorStart: Colors.yellow,
          circleColorEnd: Colors.orange,
          dotPrimaryColor: Colors.yellow,
          dotSecondaryColor: Colors.orange,
        );
      case 3:
        return ColorSplash(
          circleColorStart: Colors.blue,
          circleColorEnd: Colors.lightBlueAccent,
          dotPrimaryColor: Colors.blue,
          dotSecondaryColor: Colors.lightBlueAccent,
        );
      case 2:
        return ColorSplash(
          circleColorStart: Colors.red,
          circleColorEnd: Colors.pink,
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.pink,
        );
      case 4:
        return ColorSplash(
          circleColorStart: Colors.brown,
          circleColorEnd: const Color.fromARGB(255, 62, 40, 32),
          dotPrimaryColor: Colors.brown,
          dotSecondaryColor: const Color.fromARGB(255, 62, 40, 32),
        );
      default:
        return ColorSplash(
          circleColorStart: Colors.white,
          circleColorEnd: Colors.white,
          dotPrimaryColor: Colors.white,
          dotSecondaryColor: Colors.white,
        );
    }
  }
}
