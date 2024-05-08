import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/exam_attempt_overview.dart';
import 'package:isms/models/admin_models/exam_deadline.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/screens/admin_screens/admin_console/overview_section.dart';
import 'package:isms/views/widgets/admin_console/admin_actions.dart';
import 'package:isms/views/widgets/admin_console/users_performance_overview_section.dart';
import 'package:isms/views/widgets/custom_data_table.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late AdminState adminState;
  String _CSRF_TOKEN = '';
  String _JWT = '';

  /// Initializes state with default data and sets up admin state.
  @override
  void initState() {
    super.initState();

    adminState = AdminState();
    _fetchAllDomainCourses();
    _fetchAllDomainUsers();
    _fetchExamDeadlines();
    _fetchRecentExamAttempts();
    // Default data is set for initial display
    // _usersDataBarChart = updateUsersDataOnDifferentCourseExamSelectionBarChart('py102ex');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _CSRF_TOKEN = Provider.of<CsrfTokenProvider>(context).csrfToken;
    _JWT = Provider.of<CsrfTokenProvider>(context).jwt;
  }

  // Map _allUsers = {};
  bool isHoveringOverSection = false;

  String url = 'http://127.0.0.1:5000/api?query=';

  void _updateBarDataOnExamSelection(String? examKey) {
    setState(() {
      selectedExam = examKey!;
    });
  }

  List<Color> coursesCompletedGradientColors = [
    ThemeConfig.primaryColor!,
    Colors.redAccent,
  ];
  List<Color> coursesEnrolledGradientColors = [
    Colors.pink!,
    Colors.orange,
  ];
  List<Color> userActivityGradientColors = [
    Colors.green,
    Colors.orangeAccent,
  ];

  var selectedExam = '';

  List<CourseInfo> _courses = [CourseInfo(courseId: 'none', courseTitle: 'none')];

  List<UsersSummaryData> _allDomainUsersSummary = [];
  List<ExamDeadline> _examDeadlines = [];

  List<ExamAttemptOverview> _recentExamAttempts = [];
  bool _coursesLoaded = false;
  bool _examsDeadlinesLoaded = false;
  bool _recentExamAttemptsLoaded = false;

  Future<dynamic> _fetchExamDeadlines() async {
    var deadlines = await adminState.getDeadlines();
    setState(() {
      _examDeadlines = deadlines;
      _examsDeadlinesLoaded = true;
    });
  }

  Future<dynamic> _fetchRecentExamAttempts() async {
    var recentExamAttempts = await adminState.getRecentExamAttempts();
    setState(() {
      _recentExamAttempts = recentExamAttempts;
      _recentExamAttemptsLoaded = true;
    });
  }

  Future<dynamic> _fetchAllDomainCourses() async {
    var courses = await adminState.getCoursesList();
    setState(() {
      _courses = [..._courses, ...courses];
      _coursesLoaded = true;
    });
  }

  // Fetch all domain users and update the state with the summary.
  Future<void> _fetchAllDomainUsers() async {
    var allUsers = await adminState.getAllUsers();
    setState(() {
      _allDomainUsersSummary = allUsers;
    });
  }

  String tapIndex = "";

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionHeader(title: AppLocalizations.of(context)!.overview),
                // SizedBox(
                //   height: 10,
                // ),
                _examsDeadlinesLoaded && _recentExamAttemptsLoaded
                    ? OverviewSection(
                        examDeadlines: _examDeadlines,
                        recentExamAttempts: _recentExamAttempts,
                      )
                    : Center(child: CircularProgressIndicator()),
                SizedBox(
                  height: 20,
                ),

                buildSectionHeader(title: AppLocalizations.of(context)!.performanceDrilldown),
                SizedBox(
                  height: 20,
                ),
                _coursesLoaded
                    ? UsersPerformanceOverviewSection(
                        courses: _courses,
                        domainUsers: _allDomainUsersSummary,
                      )
                    : Center(child: CircularProgressIndicator()),
                buildSectionHeader(title: AppLocalizations.of(context)!.adminActions),
                SizedBox(
                  height: 20,
                ),
                _coursesLoaded
                    ? AdminActions(
                        courses: _courses,
                        allDomainUsersSummary: _allDomainUsersSummary,
                        CSRFToken: _CSRF_TOKEN,
                        JWT: _JWT,
                      )
                    : Center(child: CircularProgressIndicator()),
                UsersSummaryTable(key: ValueKey(_allDomainUsersSummary), usersList: _allDomainUsersSummary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
