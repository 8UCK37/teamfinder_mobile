import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/fifth_page.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/first_page.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/fourth_page.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/second_page.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/sixth_page.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/reaction_stats/pages/third_page.dart';

import '../../../services/data_service.dart';

class ReactionStat extends StatefulWidget {
  const ReactionStat({super.key});

  @override
  State<ReactionStat> createState() => _ReactionStatState();
}

class _ReactionStatState extends State<ReactionStat>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: MediaQuery.of(context).size.height * .97,
      decoration: BoxDecoration(
        color: userService.darkTheme!
            ? const Color.fromRGBO(46, 46, 46, 1)
            : Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            height: MediaQuery.of(context).size.height * .939,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                automaticallyImplyLeading: false,
                bottom: TabBar(
                  controller: tabController,
                  indicatorColor: Colors.deepPurple,
                  unselectedLabelColor: Colors.grey,
                  tabs:   [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Center(
                        child: Text(
                          "All",
                          style: TextStyle(color: Colors.blue),
                          ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Image(
                        image: AssetImage("assets/images/fire.gif"),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Image(
                        image: AssetImage("assets/images/haha.gif"),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Image(
                        image: AssetImage("assets/images/love.gif"),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Image(
                        image: AssetImage("assets/images/sad.gif"),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.red)),
                      height: 35,
                      width: 35,
                      child: const Image(
                        image: AssetImage("assets/images/poop.gif"),
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: const [
                  FirstStat(),
                  SecondStat(),
                  ThirdStat(),
                  FourthPage(),
                  FifthStat(),
                  SixthStat()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
