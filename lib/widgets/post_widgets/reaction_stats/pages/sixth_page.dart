import 'package:flutter/material.dart';

class SixthStat extends StatefulWidget {
  const SixthStat({super.key});

  @override
  State<SixthStat> createState() => _SixthStatState();
}

class _SixthStatState extends State<SixthStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
    );
  }
}