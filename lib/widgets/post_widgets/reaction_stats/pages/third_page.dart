import 'package:flutter/material.dart';

class ThirdStat extends StatefulWidget {
  const ThirdStat({super.key});

  @override
  State<ThirdStat> createState() => _ThirdStatState();
}

class _ThirdStatState extends State<ThirdStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
    );
  }
}