import 'package:debt_frontend/views/login/login_contract.dart';
import 'package:flutter/material.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> implements LoginContract {
  late LoginPresenter _loginPresenter;
  String _username = "";
  String _password = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginPresenter = LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                TextFormField(
                  cursorColor: const Color.fromRGBO(255, 255, 255, 0.7),
                  onChanged: (text) {
                    _username = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Username",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  cursorColor: const Color.fromRGBO(255, 255, 255, 0.7),
                  onChanged: (text) {
                    _password = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginPresenter.loginAccount(_username, _password);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(35),
                        ),
                        child: const Text("Login"),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(35),
                        ),
                        child: const Text("Register"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  @override
  void onLoginFailed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Text("Login failed"),
          );
        }
    );
  }

  @override
  void onLoginSucceeded() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Text("Login succeed"),
          );
        }
    );
  }
}