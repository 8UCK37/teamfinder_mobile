import 'package:flutter/material.dart';

class SecondStat extends StatefulWidget {
  const SecondStat({super.key});

  @override
  State<SecondStat> createState() => _SecondStatState();
}

class _SecondStatState extends State<SecondStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
    );
  }
}