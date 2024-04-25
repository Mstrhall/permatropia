import 'package:admin/services/login.service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: 'mathis.loup@my-digital-school.org');
  final TextEditingController _passwordController = TextEditingController(text: 'azerty123');

  final LoginService _loginService = LoginService();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    dynamic token = await _loginService.login(username, password);

  print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}