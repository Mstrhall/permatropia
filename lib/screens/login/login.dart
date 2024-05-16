import 'package:admin/models/credentials.dart';
import 'package:admin/screens/expenses/expenses.dart';
import 'package:admin/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'mathis.loup@my-digital-school.org');
  final TextEditingController _passwordController =
      TextEditingController(text: 'azerty123');

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

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var authService = Provider.of<AuthService>(context, listen: false);

    var credential = Credential(email: username, password: password);

    print('Attemps to connect with : $password and $username');
    authService.login(credential).then((message) {
      if (authService.isLoggedIn) {
        // Redirect logic here after successful login
        // For example, navigate to another screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text("Failed to login"),
          ),
        );
      }
    });
  }
}
