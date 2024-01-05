import 'package:flutter/material.dart';

class FirstStat extends StatefulWidget {
  const FirstStat({super.key});

  @override
  State<FirstStat> createState() => _FirstStatState();
}

class _FirstStatState extends State<FirstStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.green)),
    );
  }
}