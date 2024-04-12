import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class CsrfTokenProvider with ChangeNotifier {
  String _csrfToken = '';
  String _jwt = '';

  String get csrfToken => _csrfToken;

  String get jwt => _jwt;

  static final Logger _logger = Logger('CSRF Token Handler');

  void setCsrfToken(String token) {
    _logger.info('Generating new token..............');
    _logger.info(token);
    _csrfToken = token;
    notifyListeners();
  }

  void setTokens(String jwt, String csrfToken) {
    _logger.info('Generating new jwt and CSRF Token..............');

    _jwt = jwt;
    _csrfToken = csrfToken;
    _logger.info(_jwt);
    _logger.info(_csrfToken);
    notifyListeners();
  }
}
