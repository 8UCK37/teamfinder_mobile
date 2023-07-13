import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> images;
  const CustomCarousel({super.key, required this.images});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int currentIndex = 0;
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            controller: controller,
            onPageChanged: (index) {
              currentIndex = index % widget.images.length;
              setState(() {
                  currentIndex = index % widget.images.length;
                });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    widget.images[index % widget.images.length],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.images.length; i++)
              buildIndicator(currentIndex == i)
              
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  controller.jumpToPage(currentIndex - 1);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: () {
                  controller.jumpToPage(currentIndex + 1);
                },
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
