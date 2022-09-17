import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  User? user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>> signInUsingEmailPassword(
      {required String username, required String password}) async {
    bool status = false;
    String title = 'Oops';
    String message = '';
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      status = true;
      title = 'Bienvenido';
      message = 'Bienvenido a pizzeria mellizos';
      user = userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          message = 'No se encontró un usuario el correo proveido';
          // print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          message = 'Contraseña incorrecta';
          // print('Wrong password provided.');
        } else if (e.code == 'invalid-email') {
          message = 'Correo con nformato invalido';
        } else {
          message = e.message ?? 'error interno con firebase';
        }
      } else {
        message = 'Ha Ocurrido un error interno.';
      }
    }

    return {'status': status, 'user': user, 'title': title, 'message': message};
  }
}
