import 'package:flutter/material.dart';

class FifthStat extends StatefulWidget {
  const FifthStat({super.key});

  @override
  State<FifthStat> createState() => _FifthStatState();
}

class _FifthStatState extends State<FifthStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 0, 253, 8))),
    );
  }
}