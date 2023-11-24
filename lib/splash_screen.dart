import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:toll_system_final0/Client/Auth/provider/provider.dart';
import 'package:toll_system_final0/Client/Screens/client_map.dart';
import 'package:toll_system_final0/Client/Screens/home_screen.dart';
import 'package:toll_system_final0/Client/Screens/sign_in.dart';
import 'package:toll_system_final0/Client/auth_page.dart';
import 'package:toll_system_final0/splash_screen_notifier.dart';
import 'package:toll_system_final0/widgets/loading.dart';

import 'Admin/Auth/admin_auth.dart';
import 'Admin/admin_page.dart';
// import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // late AnimationController _controller;

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  // Remove the existing loaded state.

  @override
  void initState() {
    super.initState();
    // checkGps();

    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 4));
    // _controller.addListener(() {
    //   if (_controller.isCompleted) {
    //     // Navigate to the admin page or client page depending on which button was clicked.
    //   }
    // });
  }

  @override
  void dispose() {
    // _controller.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the notifier instance using Provider.
    final notifier = Provider.of<SplashScreenNotifier>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (notifier.user == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/toll.avif',
                      width: 300, // Adjust the width as needed
                      height: 250, // Adjust the height as needed
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to Toll Collection System!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAuth(),
                          ),
                        );
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
                          horizontal: 20,
                        ),
                        child: Text(
                          'Toll Handler',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        child: Text(
                          'Client',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )
              : Loading(child: Text("Loading")),
        ),
      ),
    );
  }

  // checkGps() async {
  //   servicestatus = await Geolocator.isLocationServiceEnabled();
  //   if (servicestatus) {
  //     permission = await Geolocator.checkPermission();

  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         print('Location permissions are denied');
  //       } else if (permission == LocationPermission.deniedForever) {
  //         print('Location permissions are permanently denied');
  //       } else {
  //         haspermission = true;
  //       }
  //     } else {
  //       haspermission = true;
  //     }

  //     if (haspermission) {
  //       // Use the notifier to set the loaded state.
  //       Provider.of<SplashScreenNotifier>(context, listen: false)
  //           .setLoaded(true);
  //     }
  //   } else {
  //     print('GPS Service is not enabled, turn on GPS location');
  //   }

  //   // Use the notifier to set the loaded state.
  //   Provider.of<SplashScreenNotifier>(context, listen: false).setLoaded(true);
  // }
}
