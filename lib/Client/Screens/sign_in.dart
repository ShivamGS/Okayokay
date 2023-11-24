import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toll_system_final0/Admin/Widgets/snackbar.dart';
// import 'package:provider/provider.dart';
import 'package:toll_system_final0/Client/Auth/auth/auth_services.dart';
import 'package:toll_system_final0/Client/Auth/provider/provider.dart';
import 'package:toll_system_final0/Client/Screens/home_screen.dart';

import '../Auth/model/user.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _handleSignIn(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.getuser() == null) {
      User? _user = await _authService.signIn(email: email, password: password);

      if (_user != null) {
        userProvider.setUser(_user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showCustomSnackBar(context, "");
      }
    } else {
      showCustomSnackBar(context, "Some user already logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleSignIn(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
