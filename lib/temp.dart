// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserInfo extends StatefulWidget {
//   const UserInfo({super.key});

//   @override
//   State<UserInfo> createState() => _UserInfoState();
// }

// class _UserInfoState extends State<UserInfo> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: StreamBuilder(
//           stream: _firestore.collection("Users").snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: Text("No data"));
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: ListView.builder(
//                     itemCount: snapshot.data!.size,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: ListTile(
//                             title: Text(snapshot.data!.docs[index]
//                                     ["First Name"] +
//                                 " " +
//                                 snapshot.data!.docs[index]["Last Name"]),
//                             subtitle: Text(
//                                 snapshot.data!.docs[index]["Vehicle number"]),
//                           ),
//                         ),
//                       );
//                     }),
//               );
//             }
//           }),
//     ));
//   }
// }



// _getCurlocation();
    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
    //     locationSettings: const LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // )).listen((Position? position) {
    //   if (position == null) {
    //     // Fluttertoast.showToast(msg: "Position Cannot be located");
    //   } else {
    //     _getCurlocation();
    //     setState(() {});
    //   }
    // });



      // Future<Position> _getCurlocation() async {
  //   _position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best);
  //   _kGooglePlex = CameraPosition(
  //     target: LatLng(_position.latitude, _position.longitude),
  //     zoom: 14.4746,
  //   );

  // setState(() {
  //   loaded = true;
  // });

  //   Circle c = Circle(
  //     circleId: CircleId("My Location"),
  //     center: LatLng(_position.latitude, _position.longitude),
  //     radius: 100,
  //     strokeColor: Colors.blue.withOpacity(0.5),
  //     fillColor: Colors.blue.withOpacity(0.5),
  //   );
  //   circles.add(c);

  //   return _position;
  // }


  // Future<void> addlocation(LatLng latlang) async {
  //   // setState(() {
  //   //   markers.add(Marker(
  //   //     markerId: MarkerId("Toll1"),
  //   //     position: latlang,
  //   //   ));
  //   // });

  //   // Store the coordinates in Firebase.
  //   await _firestore.collection('Tolls').add({
  //     'latitude': latlang.latitude,
  //     'longitude': latlang.longitude,
  //   });
  // }
