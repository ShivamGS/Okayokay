import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toll_system_final0/Client/Screens/sign_in.dart';
import 'package:toll_system_final0/Client/Screens/sign_up.dart';
import 'Auth/auth/auth_services.dart';
import 'Screens/home_screen.dart';
import 'Auth/provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    final userProvider = Provider.of<UserProvider>(context);
    print(userProvider.getuser());

    return Scaffold(
      body: Center(
        child: userProvider.getuser() == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              )
            : HomeScreen(),
      ),
    );
  }
}
