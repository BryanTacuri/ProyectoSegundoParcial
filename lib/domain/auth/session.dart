import 'package:app_pizzeria/data/user/user_data.dart';
import 'package:app_pizzeria/domain/response/domain_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDomain {
  final UserData _userData = UserData();
  Future<DomainResponse> doLogin(
      {required String username, required String password}) async {
    bool status = false;
    String title = '';
    String message = '';
    User? user;
    try {
      final response = await _userData.signInUsingEmailPassword(
          username: username, password: password);
      status = response['status'] ?? false;
      title = response['title'] ?? '';
      message = response['message'] ?? '';
      user = response['user'];
    } catch (e) {
      status = false;
      title = 'Oops...';
      message = 'Ha Ocurrido un error interno.';
    }
    return DomainResponse(
        status: status, message: message, title: title, data: user);
  }

  Future<void> closeSession() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.signOut();
  }
}
