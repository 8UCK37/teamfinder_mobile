import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/custom_reaction.dart';
import 'package:teamfinder_mobile/widgets/reaction_widgets/reaction_splash_color.dart';

class CustomReactionOverlay extends StatefulWidget {
  const CustomReactionOverlay({
    super.key,
    required this.onDismiss,
    required this.onPressReact,
    required this.relativeRect,
    required this.overlaySize,
    required this.reactions,
    this.backgroundColor,
    this.size,
  });
  final Function() onDismiss;
  final Function(int) onPressReact;
  final List<String> reactions;
  final RelativeRect relativeRect;
  final double overlaySize;
  final Color? backgroundColor;
  final Size? size;

  @override
  State<CustomReactionOverlay> createState() => _CustomReactionOverlayState();
}

class _CustomReactionOverlayState extends State<CustomReactionOverlay>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInSine,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          GestureDetector(
              onVerticalDragUpdate: (details) {
                //debugPrint('caught onVerticalDragUpdate ${details.toString()}');
                widget.onDismiss();
              },
              onHorizontalDragUpdate: (details) {
                //debugPrint('caught onHorizontalDragUpdate ${details.toString()}');
                widget.onDismiss();
              },
              child: ModalBarrier(onDismiss: widget.onDismiss)),
          Positioned.fromRelativeRect(
            rect: widget.relativeRect,
            child: SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Material(
                  type: MaterialType.card,
                  elevation: 20,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: widget.overlaySize,
                    constraints:
                        const BoxConstraints(maxHeight: 60, minHeight: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: widget.backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < widget.reactions.length; i++)
                          CustomReaction(
                            path: widget.reactions[i],
                            onTap: widget.onPressReact,
                            index: i,
                            size: widget.size ?? const Size(45, 45),
                            colorSplash: ColorSplash.getColorPalette(i),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
