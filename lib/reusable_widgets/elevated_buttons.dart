import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  final Function()? onTap;
  const ElevatedBtn({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child:ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
    );
  }
}
