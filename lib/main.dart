import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import 'package:toll_system_final0/Admin/Widgets/snackbar.dart';
import 'package:toll_system_final0/splash_screen.dart';
import 'package:toll_system_final0/splash_screen_notifier.dart';
import 'package:toll_system_final0/widgets/loading.dart';

import 'Client/Auth/auth/auth_services.dart';
import 'Client/Auth/provider/provider.dart';
import 'Client/Screens/home_screen.dart' as home;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBJDI1cbVgxfCpg43uOgpNFPghhjrnMPbU",
          appId: "1:183430296025:android:a8236c90448ee91e2d29c8",
          messagingSenderId: "183430296025",
          projectId: "shivam-8fa63",
          storageBucket: 'shivam-8fa63.appspot.com'));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenNotifier()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers if needed.
      ],
      child: const MyApp(),
    ),
  );
  // Razorpay razorpay = Razorpay();
  // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
  // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
}

// void handlePaymentSuccess(PaymentSuccessResponse response) {
//   print('Payment success: ${response.paymentId}');
//   // Handle success, e.g., mark the toll as paid in your Firebase database
// }

// void handlePaymentError(PaymentFailureResponse response) {
//   print('Payment error: ${response.code} - ${response.message}');
//   // Handle error, e.g., show an error message to the user
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
