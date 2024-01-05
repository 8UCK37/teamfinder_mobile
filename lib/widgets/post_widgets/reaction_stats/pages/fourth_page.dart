import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
    );
  }
}