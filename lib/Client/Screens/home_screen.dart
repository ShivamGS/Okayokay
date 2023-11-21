import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toll_system_final0/Admin/Widgets/snackbar.dart';
import 'package:toll_system_final0/Client/Screens/client_map.dart';
import 'package:toll_system_final0/Client/Screens/razor_payscreen.dart';

import '../Auth/provider/provider.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomeContent(), LocationMonitor(), RazePay()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toll System'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'RazorPay',
          ),
        ],
      ),
    );
  }
}
