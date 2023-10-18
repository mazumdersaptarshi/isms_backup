import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:isms/utitlityFunctions/auth_service.dart';

class LoginLogic {
  final AuthService _authService = AuthService();

  Future<User?>? signInWithGoogle(CustomUserProvider customUserProvider) {
    return _authService.signInWithGoogle(customUserProvider);
  }

  Future<void> setLoggedInUser(CustomUserProvider customUserProvider) async {
    await customUserProvider.fetchUsers();
    customUserProvider.users.forEach((element) {
      if (element.email == FirebaseAuth.instance.currentUser?.email) {
        customUserProvider.setLoggedInUser(element);
      }
    });
  }

  Future<void> createUserIfNotExists(User? user) async {
    await CreateUserDataOperations().checkAndCreateUserIfNotExists(user);
  }
}
