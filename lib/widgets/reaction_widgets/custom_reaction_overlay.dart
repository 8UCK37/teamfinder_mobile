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
  final List<int> _animatedIndices = [];
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

    // slideAnimation = Tween<Offset>(
    //   begin: const Offset(0.0, 1.0),
    //   end: const Offset(0.0, 0.0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Curves.easeOutQuad,
    //   ),
    // );

    controller.forward().whenComplete(() {
      // Start the individual slide-up animation with a delay after the card animation is finished.
      for (int i = 0; i < widget.reactions.length; i++) {
        Future.delayed(Duration(milliseconds: 15 + i * 25), () {
          // Check if the widget is still mounted to prevent running animations on unmounted widgets.
          if (mounted) {
            setState(() {
              // Update the animation state for the specific index.
              _animatedIndices.add(i);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              widget.onDismiss();
            },
            onHorizontalDragUpdate: (details) {
              widget.onDismiss();
            },
            child: ModalBarrier(onDismiss: widget.onDismiss),
          ),
          Positioned.fromRelativeRect(
            rect: widget.relativeRect,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(
                    0.0, 1.0), // Start off the screen below the overlay
                end: const Offset(
                    0.0, 0.0), // Slide to the center of the overlay
              ).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeOutQuad,
                ),
              ),
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
                      children: [
                        for (int i = 0; i < widget.reactions.length; i++)
                          if (_animatedIndices.contains(i))
                            AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0,1), // Slide in from below the overlay
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: controller,
                                    curve: Interval(0.15 + i * 0.25, 1.0),
                                  )),
                                  child: child,
                                );
                              },
                              child: CustomReaction(
                                path: widget.reactions[i],
                                onTap: widget.onPressReact,
                                index: i,
                                size: widget.size ?? const Size(45, 45),
                                colorSplash: ColorSplash.getColorPalette(i),
                                animationController: controller,
                              ),
                            ),
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
