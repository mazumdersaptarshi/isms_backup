import 'package:flutter/material.dart';

//import 'course_sidebar.dart'; // Import the sidebar widget
import 'package:flutter_html/flutter_html.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int currentSection = 0;
  final List<String> sections = [
    'Introduction',
    'Contact Center AI (CCAI)',
    'Key Takeaways',
    'Review', // New section
  ];

  final List<String> htmlContent = [
    '''
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interactive Course</title>
    <style>
        .course-section {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }


        .hidden {
            display: none;
        }


        .flip-card {
            background-color: transparent;
            width: 300px;
            height: 200px;
            perspective: 1000px;
            margin-bottom: 20px;
        }


        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            transition: transform 0.6s;
            transform-style: preserve-3d;
            cursor: pointer;
        }


        .flip-card-front, .flip-card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
        }


        .flip-card-front {
            background-color: #bbb;
            color: black;
        }


        .flip-card-back {
            background-color: #2980b9;
            color: white;
            transform: rotateY(180deg);
        }
    </style>
</head>
<h2 style="text-align: center; color: black; font-weight: bold;">Introduction</h2>
<hr style="background-color: purple;">
<p>This introductory section will provide an overview of the course. You will learn about the basic concepts and get familiar with the key terms used throughout the course.</p>
<hr>
    ''',
    '''
<h2 style="text-align: center; color: black; font-weight: bold;">Contact Center AI (CCAI)</h2>
<hr style="background-color: purple;">
<p>In this section, we'll delve into the world of Contact Center AI. You'll learn about its functionalities, how it improves customer service, and the technology that drives it.</p>
<hr>
    ''',
    '''
<h2 style="text-align: center; color: black; font-weight: bold;">Key Takeaways</h2>
<hr style="background-color: purple;">
<ul>
    <li>Understanding the basics of CCAI and its impact on customer service.</li>
    <li>Key functionalities and advantages of using CCAI in business.</li>
    <li>Strategies for implementing CCAI effectively.</li>
</ul>
<hr>
    ''',
    '''
<h2 style="text-align: center; color: black; font-weight: bold;">Review</h2>
<hr style="background-color: purple;">
<p>This final review section will cover key aspects and takeaways from the course.</p>
<hr>
    ''',
  ];

  List<Widget> getContentWidgets() {
    List<Widget> contentWidgets = [];
    for (int i = 0; i <= currentSection; i++) {
      contentWidgets.add(Html(data: htmlContent[i]));
      if (i < currentSection) {
        contentWidgets.add(const SizedBox(height: 10)); // Adjusted size for less spacing
      }
    }

    // Flip cards in the "Review" section
    if (currentSection == sections.length - 1) {
      contentWidgets.addAll([
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10.0,
          runSpacing: 10.0,
          children: List.generate(4, (index) => FlipCard(content: 'Content for Card ${index + 1}')),
        ),
        const SizedBox(height: 20),
      ]);
    }

    return contentWidgets;
  }

  void goToNextSection() {
    if (currentSection < sections.length - 1) {
      setState(() {
        currentSection++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      //drawer: const SidebarWidget(),
      drawerScrimColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...getContentWidgets(),
            if (currentSection < sections.length - 1)
              ElevatedButton(
                onPressed: goToNextSection,
                child: const Text('Next Section'),
              ),
          ],
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final String content;

  const FlipCard({Key? key, required this.content}) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(_controller.value * 3.14),
            child: _controller.value <= 0.5
                ? Container(
              width: 300,
              height: 200,
              color: Colors.deepPurpleAccent.shade100,
              alignment: Alignment.center,
              child: const Text('Flip Me', style: TextStyle(fontSize: 20, color: Colors.white)),
            )
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.14),
              child: Container(
                width: 300,
                height: 200,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Text(widget.content, style: const TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}
