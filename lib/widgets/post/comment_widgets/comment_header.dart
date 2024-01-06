import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/data_service.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: userService.darkTheme!
                    ? const Color.fromRGBO(48, 48, 48, 1)
                    : Colors.white),
            height: 65,
            child: Padding(
                padding: const EdgeInsets.only(left: 22.0, right: 22),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Container(
                            height: 5,
                            width: 60,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        )
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Comments",
                            style: TextStyle(
                              color: userService.darkTheme!? Colors.white:Colors.black,
                              fontSize: 20),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.close),
                            ),
                          )
                        ]),
                  ],
                )),
          ),
          Divider(
            height: 0,
            color: userService.darkTheme!
                ? Colors.grey
                : const Color.fromARGB(255, 36, 36, 36),
          ),
        ],
      ),
    );
  }
}
