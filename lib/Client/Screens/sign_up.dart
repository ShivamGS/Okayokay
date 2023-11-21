import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toll_system_final0/Admin/Widgets/snackbar.dart';
import 'package:toll_system_final0/Client/Auth/auth/auth_services.dart';
import 'package:toll_system_final0/Client/Auth/provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  final AuthService _authService = AuthService();

  void _handleSignup(BuildContext context) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String mobileNumber = _mobileNumberController.text;
    String vehicleNumber = _vehicleNumberController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    User? _user = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        vehicleNumber: vehicleNumber);

    if (_user != null) {
      userProvider.setUser(_user);
    }

    if (_user == null) {
      showCustomSnackBar(context, "Some error happned");
    }

    // print(userProvider.getuser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // Hide the password input.
            ),
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(labelText: 'Vehicle Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleSignup(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
