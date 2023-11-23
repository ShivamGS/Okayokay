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
      body: (notifier.user == null)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPage()),
                          );
                        },
                        child: Text('Admin'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthScreen(),
                            ),
                          );
                        },
                        child: Text('Client'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Loading(child: Text("Loading")),
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
