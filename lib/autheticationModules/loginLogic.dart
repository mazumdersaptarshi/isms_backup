import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/databaseOperations/databaseManager.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/utitlityFunctions/auth_service.dart';

class LoginLogic {
  final AuthService _authService = AuthService();

  Future<User?>? signInWithGoogle(LoggedInUserProvider customUserProvider) {
    return _authService.signInWithGoogle(customUserProvider);
  }

  Future<void> createUserIfNotExists(User? user) async {
    await CreateUserDataOperations().checkAndCreateUserIfNotExists(user);
  }
}