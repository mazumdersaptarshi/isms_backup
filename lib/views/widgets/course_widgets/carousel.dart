import 'package:flutter/material.dart';
import '../../screens/course_page.dart';
import '../shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/screens/home_screen.dart';

class Carousel extends StatefulWidget {
  List<CourseData> courseData;
  double cardWidth; // Make cardWidth a non-final property

  Carousel({
    Key? key,
    required this.courseData,
    this.cardWidth = 400.0,
  }) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  ScrollController _scrollController = ScrollController();

  Color _leftHoverColor = Colors.grey.withOpacity(0.5);
  Color _rightHoverColor = Colors.grey.withOpacity(0.5);

  int _hoveredCardIndex = -1;

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
                widget.courseData.length,
                    (index) => LayoutBuilder(
                  builder: (context, constraints) => _buildCarouselItem(
                    widget.courseData[index],
                    constraints.maxWidth,
                    index,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned arrow buttons with GestureDetector
        Positioned(
          left: 10.0,
          top: 80.0,
          child: MouseRegion(
            onEnter: (event) => setState(() {
              _leftHoverColor = Colors.grey.withOpacity(0.3);
            }),
            onExit: (event) => setState(() {
              _leftHoverColor = Colors.grey.withOpacity(0.5);
            }),
            child: GestureDetector(
              onTap: () => _scrollToLeft(),
              child: Container(
                decoration: ShapeDecoration(
                  color: _leftHoverColor,
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
        ),
        Positioned(
          right: 10.0,
          top: 80.0,
          child: MouseRegion(
            onEnter: (event) => setState(() {
              _rightHoverColor = Colors.grey.withOpacity(0.3);
            }),
            onExit: (event) => setState(() {
              _rightHoverColor = Colors.grey.withOpacity(0.5);
            }),
            child: GestureDetector(
              onTap: () => _scrollToRight(),
              child: Container(
                decoration: ShapeDecoration(
                  color: _rightHoverColor,
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
        ),
      ],
    );
  }

  Widget _buildCarouselItem(courseData, double width, int cardIndex) {
    final defaultCardColor = Colors.grey.shade100; // Very light grey, close to white
    final hoverCardColor = Colors.grey.shade50;

    Color cardColor = _hoveredCardIndex == cardIndex ? hoverCardColor : defaultCardColor;
    return MouseRegion(
      onEnter: (event) => setState(() {
        _hoveredCardIndex = cardIndex;
      }),
      onExit: (event) => setState(() {
        _hoveredCardIndex = -1; // Reset when no card is hovered
      }),
      child: GestureDetector(
      onTap: () {
        // Navigate to CoursePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursePage(courseId: "ip78hd"),
          ),
        );
      },
        child: Card(
          color: cardColor,
          child: Container(
            width: widget.cardWidth,
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  courseData?.image ?? "assets/images/course_images/3D_Printing_From_Design_to_Prototype.jpeg",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover, // Ensure image fills the space
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    courseData?.title ?? "No Title",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4, // Allow up to 3 lines before fading
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
                CustomLinearProgressIndicator(
                  value: (2 / 5), // Assuming progress of 1/3 for demonstration
                  backgroundColor: Colors.blue.shade100,
                  valueColor: Colors.blue.shade300,
                ),
            ],
          ),
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