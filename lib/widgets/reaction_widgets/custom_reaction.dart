import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:like_button/like_button.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';

class CustomReaction extends StatefulWidget {
  const CustomReaction(
      {super.key,
      required this.path,
      required this.onTap,
      required this.index,
      required this.size,
      required this.colorSplash});
  final String path;
  final int index;
  final Size size;
  final Function(int) onTap;
  final ColorSplash colorSplash;

  @override
  State<CustomReaction> createState() => _CustomReactionState();
}

class _CustomReactionState extends State<CustomReaction>
    with TickerProviderStateMixin {
  late AnimationController iconScaleController;
  late AnimationController slideController;
  final player = AudioPlayer();
  double padding = 0;
  @override
  void initState() {
    super.initState();
    player.audioCache.prefix = "packages/flutter_animated_reaction/";
    iconScaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    iconScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -0.3))
          .animate(
        CurvedAnimation(
          curve: Curves.linear,
          parent: slideController,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          iconScaleController.forward().whenComplete(() async {
            await player.play(AssetSource("assets/audio/pop.mp3"));
            widget.onTap(widget.index);
          });
        },
        onPanStart: (details) {
          slideController.forward();
          iconScaleController.forward();
          setState(() {
            padding = 10;
          });
        },
        onPanUpdate: (details) {
          slideController.forward();
          iconScaleController.forward();
          setState(() {
            padding = 10;
          });
        },
        onPanEnd: (details) {
          iconScaleController.reverse();
          slideController.reverse();
          setState(() {
            padding = 0;
          });
        },
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.5).animate(
            CurvedAnimation(
              curve: Curves.fastEaseInToSlowEaseOut,
              parent: iconScaleController,
            ),
          ),
          child: AnimatedPadding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              duration: const Duration(milliseconds: 200),
              child: LikeButton(
                size: 45,
                circleColor:  CircleColor(
                    start: widget.colorSplash.circleColorStart, 
                    end: widget.colorSplash.circleColorEnd
                    ),
                bubblesColor:  BubblesColor(
                  dotPrimaryColor: widget.colorSplash.dotPrimaryColor,
                  dotSecondaryColor: widget.colorSplash.dotSecondaryColor,
                ),
                likeBuilder: (bool isLiked) {
                  return SizedBox(
                    height: 45,
                    width: 45,
                    child: Image(
                      image: AssetImage(widget.path),
                      width: widget.size.width,
                      height: widget.size.height,
                    ),
                  );
                },
                likeCount: null,
              )),
        ),
      ),
    );
  }
}
