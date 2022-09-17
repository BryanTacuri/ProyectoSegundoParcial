import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/domain/auth/login.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String username = '';
  String password = '';
  bool isLoading = false;

  goToHome() {
    Navigator.pushReplacementNamed(context, 'home');
  }

  doLogin() async {
    setState(() {
      isLoading = true;
    });
    LoginDomain login = LoginDomain();
    final response =
        await login.doLogin(password: password, username: username);
    if (response.status) {
      goToHome();
    } else {
      Utils.showScaffoldNotification(
          context: context,
          title: response.title,
          message: response.message,
          type: 'error');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Color.fromARGB(255, 181, 180, 180));
    GlobalKey<FormState> myform = GlobalKey();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: Utils.getSize(context).height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(colors: [
                    Colors.indigo,
                    Color.fromARGB(255, 161, 63, 181),
                    Color.fromARGB(255, 161, 63, 181),
                  ])),
              child: Form(
                key: myform,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    TextFormField(
                      style: textStyle,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validator,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      onChanged: ((value) {
                        username = value.trim();
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: textStyle,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validator,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Password',
                      ),
                      onChanged: ((value) {
                        password = value;
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (myform.currentState?.validate() ??
                                      false) {
                                    doLogin();
                                  } else {
                                    Utils.showScaffoldNotification(
                                        context: context,
                                        message:
                                            'Ingrese la información requerida',
                                        type: 'error',
                                        title: 'Atención');
                                  }
                                },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Iniciar Sesión')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validator(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }
}
