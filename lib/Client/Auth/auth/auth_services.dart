import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toll_system_final0/Client/Auth/model/user.dart'
    as u; // Alias the User model

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String vehicleNumber,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Create a user object with additional details
      u.UserModel userData = u.UserModel(
        uid: user!
            .uid, // You can assign the user's Firebase UID to the user object
        firstName: firstName,
        lastName: lastName,
        password: password,
        email: email,
        mobileNumber: mobileNumber,
        vehicleNumber: vehicleNumber,
      );

      // Store user data in Firestore (assuming you have a "users" collection)
      await _firestore.collection("Users").doc(user.uid).set(userData.toJson());

      return user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
