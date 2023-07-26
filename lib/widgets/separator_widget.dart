import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SeparatorWidget extends StatelessWidget {
  Color? color=Colors.grey[400];
  SeparatorWidget({super.key,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: MediaQuery.of(context).size.width,
      height: 11.0,
    );
  }
}
