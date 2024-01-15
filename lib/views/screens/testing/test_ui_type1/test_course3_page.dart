import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/screens/testing/test_course2_exam1_page.dart';
import 'package:isms/views/screens/testing/test_ui_type1/quizcard.dart';
// import 'package:isms/views/screens/testing/test_ui/quizcard.dart';
// import 'package:isms/views/screens/testing/test_ui/sidebar.dart';
// import 'package:isms/views/screens/testing/test_ui/themes.dart';
import 'package:isms/views/screens/testing/test_ui_type1/sidebar.dart';
import 'package:isms/views/screens/testing/test_ui_type1/themes.dart';
import 'package:provider/provider.dart';

import 'expansion_tile.dart';
import 'flipcard.dart';

class DocumentAIPage extends StatefulWidget {
  @override
  State<DocumentAIPage> createState() => _DocumentAIPageState();
}

class _DocumentAIPageState extends State<DocumentAIPage> {
  int sectionIndex = 0;

  int totalSections = 4;

  String courseId3 = 'hd78hb';

  Future<void> _nextSection(
      LoggedInState loggedInState, BuildContext context) async {
    if (sectionIndex < totalSections - 1) {
      setState(() {
        sectionIndex++;
      });
      await loggedInState
          .updateUserProgress(fieldName: 'courses', key: courseId3, data: {
        'courseId': courseId3,
        'completionStatus': 'completed',
        'currentSection': 'py1',
        'completedSections': ['py1'],
      });
    } else {
      // Go to assessment
      print('Go to Assessment');
    }
  }

  void _previousSection() {
    if (sectionIndex > 0) {
      setState(() {
        sectionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('ISMS'),
        backgroundColor: Colors.grey[850],
      ),
      drawer: CustomDrawer(), // Add widgets to the drawer here

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 200, right: 100.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (sectionIndex > 0)
                    ElevatedButton(
                        onPressed: () => _previousSection(),
                        child: Text('Previous Section')),
                  Stack(
                    children: <Widget>[
                      Text(
                        'What is Document AI?',
                        style: AppThemes.headingStyle,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 4,
                          width: 200, // Adjust the width for half underline
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Divider(color: Colors.blue, thickness: 2.0),
                  SizedBox(height: 8),
                  SectionContent(
                    sectionIndex: sectionIndex,
                  ),
                  if (sectionIndex != totalSections - 1)
                    ElevatedButton(
                        onPressed: () => _nextSection(loggedInState, context),
                        child: Text('Next Section')),
                  if (sectionIndex == totalSections - 1)
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TestCourse2Exam1Page()));
                        },
                        child: Text('Take Assesmment')),
                  // ... Any other widgets you want to add ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBulletPoints() {
    List<String> points = [
      'Over 4 trillion paper documents in the US, growing at 22% per year.',
      'Nearly 75% of a typical worker’s time is spent searching for and filing paper-based information ',
      '95% of corporate information exists on paper',
      '75% of all documents get lost; 3% of the remainder are misfiled',
      'Companies spend 20 in labor to file a document; 120 in labor to find a misfiled document; 220 in labor to recreate a lost document',
    ];

    return points
        .map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('     •         ',
                      style: TextStyle(
                          fontSize: 20, height: 1.75, color: Colors.blue)),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 1.7 * 10, // 1.7rem
                        fontWeight: FontWeight.w400,
                        height: 1.75,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

class SectionContent extends StatelessWidget {
  int sectionIndex;
  SectionContent({required this.sectionIndex});

  Widget _buildSectionContent(int sectionIndex) {
    switch (sectionIndex) {
      case 0:
        return Column(
          children: [
            Text(
              'Learn about the fundamentals of Document AI and how it turns unstructured content into business-ready structured data. You will focus on how Document AI uses machine learning (ML) on a scalable cloud-based platform to help customers unlock insights. You will also learn what Document AI is, determine how it works, review its use cases, and identify its competitive differentiators.',
              style: AppThemes.contentStyle,
            ),
          ],
        );
        break;
      case 1:
        return Column(
          children: [
            Text(
              'Why Document AI?',
              style: AppThemes.subHeadingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Document AI helps our customers to achieve their business goals by unlocking insights from documents using machine learning. While you may think that the use of paper is dwindling, consider these stats:',
              style: AppThemes.contentStyle,
            ),
            SizedBox(height: 8),
            ..._buildBulletPoints(),
          ],
        );
        break;
      case 2:
        return Column(
          children: [
            Text(
              'Almost every account you have will want to learn about new ways to serve their customers while improving how they leverage their data. You, on the other hand, also want to help your customers process documents while achieving your goals. Document AI can help you.',
              style: AppThemes.contentStyle,
            ),
            SizedBox(height: 16),
            Text(
              'Select each card to learn more.',
              style: AppThemes.subHeadingStyle,
            ),
            SizedBox(height: 36),
            Center(
              child: CustomFlipCard(),
            ),
            SizedBox(height: 10),
            Center(
              child: CustomFlipCard(),
            ),
          ],
        );
        break;
      case 3:
        return Column(
          children: [
            Text(
              'The Background on Document AI',
              style: AppThemes.subHeadingStyle,
            ),
            SizedBox(height: 30),
            Text(
              'For centuries, documents have been foundational to our societies. We record histories, establish laws, legitimize trade, launch companies, and confirm identities with documents.',
              style: AppThemes.contentStyle,
            ),
            SizedBox(height: 30),
            Text(
              'The computer age has introduced the idea of digital documents, which now serve as the backbone of our modern societies, and the power and value of digital documents is immense.',
              style: AppThemes.contentStyle, // Adjust the font size as needed
            ),
            SizedBox(height: 52), // Spacing before the button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFBBC05), // Background color
                onPrimary: Colors.black, // Text color
                minimumSize: Size(double.infinity, 70), // Width and height
              ),
              onPressed: () {
                // Add your button action here
              },
              child: Text(
                'Knowledge Check',
                style: AppThemes.headingStyle,
              ),
            ),
            SizedBox(height: 20),
            QuizCard(),
            SizedBox(height: 20),
            QuizCard(),
            Divider(color: Colors.grey),
            SizedBox(height: 30), // Add some spacing
            Text(
              'Document AI Use Cases',
              style: AppThemes.subHeadingStyle,
            ),
            SizedBox(height: 20),
            Text(
              'Document AI aims to be the platform of choice for business-ready document processing, and we have specialized models for some of the world"s most commonly used business documents. These specialized or pretrained document models enable higher levels of accuracy, especially with custom document layouts, and always output the same core concepts (“schema”). We have grouped some of these specialized models into bundles that address high-value use cases.',
              style: AppThemes.contentStyle, // Adjust th
            ),
            SizedBox(height: 20),
            Text(
              'It is important to note that Document AI has been designed to address a customer’s end-to-end document workflow – but not necessarily the full business workflow. For example, Document AI can help a customer classify and extract information from an invoice, but it does not address the full accounts payable process. Customers can either integrate the Document AI API into their existing workflows (on their own, or with a systems integrator), or they can work with ISV / SaaS providers who leverage Document AI directly.',
              style: AppThemes.contentStyle,
            ),
            SizedBox(height: 20),

            ExpansionTileCard(),
            ExpansionTileCard(),
            ExpansionTileCard(),
          ],
        );
        break;
      default:
        return (SizedBox(
          height: 1,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildSectionContent(sectionIndex),
    );
  }

  List<Widget> _buildBulletPoints() {
    List<String> points = [
      'Over 4 trillion paper documents in the US, growing at 22% per year.',
      'Nearly 75% of a typical worker’s time is spent searching for and filing paper-based information ',
      '95% of corporate information exists on paper',
      '75% of all documents get lost; 3% of the remainder are misfiled',
      'Companies spend 20 in labor to file a document; 120 in labor to find a misfiled document; 220 in labor to recreate a lost document',
    ];

    return points
        .map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('     •         ',
                      style: TextStyle(
                          fontSize: 20, height: 1.75, color: Colors.blue)),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 1.7 * 10, // 1.7rem
                        fontWeight: FontWeight.w400,
                        height: 1.75,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
