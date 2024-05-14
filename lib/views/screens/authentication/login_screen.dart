import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/language_management/language_manager.dart';
import 'package:isms/controllers/notification_management/init_link_handler.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/theme_management/theme_manager.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/screens/home_screen.dart';
import 'package:isms/views/widgets/shared_widgets/loading_screen_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
// import 'dart:html' as html;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  // String localGetURL = 'http://127.0.0.1:5000/get3?flag=';
  String remoteGetURL =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get3?flag=';

  Future<dynamic> _fetchJWTandCSRFToken() async {
    // String url =
    //     'http://127.0.0.1:5000/api/auth?uid=${Provider.of<LoggedInState>(context, listen: false).currentUser!.uid}';
    String localURL =
        'http://127.0.0.1:5000/api/auth?uid=${Provider.of<LoggedInState>(context, listen: false).currentUser!.uid}';

    String remoteURL =
        'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/api/auth?uid=${Provider.of<LoggedInState>(context, listen: false).currentUser!.uid}';
    var response = await http.get(Uri.parse(remoteURL));
    var jsonResponse = jsonDecode(response.body);
    Provider.of<CsrfTokenProvider>(context, listen: false).setTokens(jsonResponse['jwt'], jsonResponse['csrf_token']);
  }

  Future<dynamic> _fetchUserSettings() async {
    print('gusfd');
    Map<String, dynamic> params = {
      "userID": Provider.of<LoggedInState>(context, listen: false).currentUser!.uid,
    };
    String jsonStringParams = jsonEncode(params);
    String encodedJsonStringParams = Uri.encodeComponent(jsonStringParams);

    http.Response response =
        await http.get(Uri.parse(remoteGetURL + 'user_settings' + '&params=$encodedJsonStringParams'));
    List<dynamic> jsonResponse = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(response.body);
    }
    try {
      print(jsonResponse.first.first);
      Provider.of<LocaleManager>(context, listen: false).setLocale(Locale(jsonResponse.first.first['language']));
      Provider.of<ThemeManager>(context, listen: false)
          .changeTheme(jsonResponse.first.first['appTheme'] == 'dark' ? ThemeModes.dark : ThemeModes.light, context);
    } catch (e) {
      Provider.of<LoggedInState>(context, listen: false).insertUpdateUserSettings(
        language: 'en',
        appTheme: 'light',
        CSRFToken: Provider.of<CsrfTokenProvider>(context, listen: false).csrfToken,
        JWT: Provider.of<CsrfTokenProvider>(context, listen: false).jwt,
      );
    }
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser != null) {
      InitLinkHandler.initLinks(context: context);
      // html.window.history.pushState({}, '', '');
      // Replace HomePage with NavigationRailWidget
      _fetchJWTandCSRFToken();
      _fetchUserSettings();
      return HomePage();
    }
    // Provider.of<CsrfTokenProvider>(context, listen: false).setCsrfToken(_newToken);

    return Scaffold(
      body: Center(
        child: _isLoading
            ? SizedBox(
                height: 200,
                width:
                    MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH ? 300 : MediaQuery.of(context).size.width,
                child: loadingWidget())
            : _getLoginPageUI(),
      ),
    );
  }

  Widget _getLoginPageUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define max width for better content management
        const double maxWidthForContent = 600;

        // Use a more consistent font size across different screen sizes
        double titleFontSize = constraints.maxWidth > 600 ? 50 : 40;
        double subTitleFontSize = constraints.maxWidth > 600 ? 20 : 16;
        double buttonFontSize = constraints.maxWidth > 600 ? 24 : 18;

        // You can adjust these paddings/margins as per your UI design
        double horizontalPadding = 40;
        double verticalPadding = 20;

        return Container(
          color: ThemeConfig.primaryColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxWidthForContent),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min to fit content size
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ISMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: Text(
                        'One app to keep track of all your pending certifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: subTitleFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        try {
                          await LoggedInState.login();
                        } catch (e) {
                          log(e.toString());
                        } finally {
                          _isLoading = false;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(LineIcons.googleLogo),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'LOGIN',
                            style: TextStyle(fontSize: buttonFontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
