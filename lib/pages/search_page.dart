import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  void initState() {
    super.initState();
    
  }
    
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('TeamFinder',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          debugPrint('goto chat');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatHome()),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.question_answer,
                              color: Colors.deepPurple),
                        ),
                      ),
                    ]),
              ]),
          backgroundColor: Colors.white,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      body: _buildSearchbarAnimation(context)
    );
  }
}
Widget _buildSearchbarAnimation(context) {
    return  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            colors: [
              Colors.deepPurple,
              Color.fromARGB(255, 185, 162, 162),
            ],
          ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomSearchBar(
                          textEditingController: TextEditingController(),
                          isOriginalAnimation: true,
                          enableKeyboardFocus: true,
                          durationInMilliSeconds: 450,
                          onExpansionComplete: () {
                            debugPrint(
                                'do something just after searchbox is opened.');
                          },
                          onCollapseComplete: () {
                            debugPrint(
                                'do something just after searchbox is closed.');
                          },
                          onPressButton: (isSearchBarOpens) {
                            debugPrint(
                                'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                          },
                          trailingWidget: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          secondaryButtonWidget: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                          buttonWidget: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    
  }
