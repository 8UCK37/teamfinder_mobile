import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/data_service.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            height: 65,
            child: Container(
              decoration: BoxDecoration(
                  color: userService.darkTheme!
                      ? const Color.fromRGBO(46, 46, 46, 1)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Theme(
                data: userService.darkTheme!
                    ? ThemeData.dark()
                    : ThemeData.light(),
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
                              const Text(
                                "Comments",
                                style: TextStyle(fontSize: 20),
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
            ),
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
