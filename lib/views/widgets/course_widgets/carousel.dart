import 'package:flutter/material.dart';
import '../../screens/course_page.dart';
import '../shared_widgets/custom_linear_progress_indicator.dart';

class Carousel extends StatefulWidget {
  final List<String> courseTitle;
  double cardWidth; // Make cardWidth a non-final property

  Carousel({
    Key? key,
    required this.courseTitle,
    this.cardWidth = 400.0,
  }) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    widget.cardWidth = screenWidth <= 500 ? screenWidth * 0.8 : widget.cardWidth; // Adjust cardWidth

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 200.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: List.generate(
                widget.courseTitle.length,
                (index) => LayoutBuilder(
                  builder: (context, constraints) => _buildCarouselItem(
                    widget.courseTitle[index],
                    constraints.maxWidth,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned arrow buttons with GestureDetector
        Positioned(
          left: 10.0,
          top: 80.0, // Adjust position based on your design
          child: GestureDetector(
            onTap: () => _scrollToLeft(),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10.0,
          top: 80.0, // Adjust position based on your design
          child: GestureDetector(
            onTap: () => _scrollToRight(),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String title, double width) {
    return GestureDetector(
      onTap: () {
        // Navigate to CoursePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoursePage()),
        );
      },
      child: Card(
        child: Container(
          width: widget.cardWidth, // Use provided cardWidth
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10.0), // Add spacing between title and progress bar
              Expanded(
                flex: 1,
                child: CustomLinearProgressIndicator(
                  value: (2 / 5), // Assuming progress of 1/3 for demonstration
                  backgroundColor: Colors.blue.shade100,
                  valueColor: Colors.blue.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToLeft() {
    double currentPosition = _scrollController.position.pixels;
    double itemWidth = widget.cardWidth; // Use provided cardWidth

    // Check if scroll position allows scrolling left (avoid going negative)
    if (currentPosition > -8) {
      _scrollController.animateTo(currentPosition - itemWidth - 8,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _scrollToRight() {
    double currentPosition = _scrollController.position.pixels;
    double itemWidth = widget.cardWidth; // Use provided cardWidth
    double maxScrollExtent = _scrollController.position.maxScrollExtent;

    // Check if scroll position allows scrolling right (avoid going beyond max extent)
    if (currentPosition < maxScrollExtent + 8) {
      _scrollController.animateTo(
        currentPosition + itemWidth + 8,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease, // You can choose other curves like Curves.linear or Curves.bounce
      );
    }
  }
}
