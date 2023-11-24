import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toll_system_final0/Client/Auth/provider/provider.dart';

class LocationMonitor extends StatefulWidget {
  @override
  _LocationMonitorState createState() => _LocationMonitorState();
}

class _LocationMonitorState extends State<LocationMonitor> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // UserProvider _userprovider = UserProvider();
  final Geolocator _geolocator = Geolocator();
  final double thresholdDistance = 600;
  Map<String, DateTime> visitedMarkers = {};
  Map<String, DateTime> time_valid = {};
  final Duration checkInterval = const Duration(minutes: 20);
  bool loaded = false;
  Position? _position;
  late User? user;

  bool _isMounted = false;

  GoogleMapController? _mapController;
  Set<Marker> markers = <Marker>{};

  Map<String, Map<String, double>> monitoredLocations = {};
  Map<String, DateTime> lastCheckTimes = {};
  String nearestLocation = "";

  double nearestLocation_distance = 0;
  @override
  void initState() {
    super.initState();
    // _loadMonitoredLocations();
    // getallMarkers();
    _requestLocationPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMounted = true;
  }

  @override
  void dispose() {
    super.dispose();

    _isMounted = false;

    // Dispose of any resources, e.g., cancel timers or stop listening to streams.
    // For example, if you have a Geolocator stream subscription, you should cancel it here.
    // _geolocatorStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.getuser();
    return (loaded)
        ? Column(
            children: [
              StyledContainer(
                child: Text(
                  "Nearest Toll is $nearestLocation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 12),
              StyledContainer(
                child: Text(
                  "Distance from nearest Toll is ${nearestLocation_distance.toStringAsFixed(3)} m",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
              Flexible(
                  child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _position?.latitude ?? 0.0,
                    _position?.longitude ?? 0.0,
                  ),
                  zoom: 100.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: markers,
              ))
            ],
          )
        : CircularProgressIndicator();
  }

  void _requestLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    if (_isMounted) {
      // Check if the widget is still mounted.
      if (permission == LocationPermission.denied) {
        // Handle denied permission.
        print("Location permission denied");
      } else if (permission == LocationPermission.deniedForever) {
        // Handle denied forever permission.
        print("Location permission denied forever");
      } else {
        // Permission granted, initialize _position and load monitored locations.
        _loadMonitoredLocations();
        getallMarkers();
      }
    }
  }

  void _loadMonitoredLocations() async {
    _firestore.collection('Tolls').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String name = doc['name'].toString();
        double latitude = double.parse(doc['latitude'].toString());
        double longitude = double.parse(doc['longitude'].toString());
        double price = double.parse(doc['price'].toString());

        monitoredLocations[name] = {
          'latitude': latitude,
          'longitude': longitude,
          'price': price,
        };
        // print(monitoredLocations[name]);
        lastCheckTimes[name] = DateTime.now();
      });
    });
  }

  void getallMarkers() async {
    await _firestore
        .collection('Tolls')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        initMarker(doc.data(), doc.id);
      });
    });

    Geolocator.getPositionStream().listen((Position position) {
      double minDistance = double.infinity; // Initialize minimum distance
      String nearest = ""; // Initialize nearest location name

      setState(() {
        _position = position;
      });
      addTemporaryMarker(LatLng(position.latitude, position.longitude));
      monitoredLocations.forEach((name, coordinates) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          coordinates['latitude']!,
          coordinates['longitude']!,
        );

        double price = coordinates['price']!;

        if (visitedMarkers.containsKey(name)) {
          DateTime orangeTimestamp = visitedMarkers[name]!;
          Duration elapsed = DateTime.now().difference(orangeTimestamp);

          // After 30 seconds, mark the marker to blue
          if (elapsed > Duration(seconds: 10)) {
            updateMarkerIcon(
                name,
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue));
            visitedMarkers
                .remove(name); // Remove the marker from the orangeMarkers map
          }

          // Skip the distance check for this marker
          return;
        }

        if (distance < minDistance) {
          minDistance = distance;
          nearest = name;
          setState(() {
            distance = minDistance;
            nearestLocation_distance = distance;
          });
        }

        if (distance <= thresholdDistance
            // &&  DateTime.now().difference(lastCheckTimes[name]!) >= checkInterval
            ) {
          // Send payment link when within 50 meters

          lastCheckTimes[name] = DateTime.now();
          updateMarkerIcon(
              name,
              BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange));
          visitedMarkers[name] = DateTime.now();
          // print("helowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");

          if (time_valid.containsKey(name)) {
            DateTime last_visited = time_valid[name]!;
            Duration el = DateTime.now().difference(last_visited);

            if (el > Duration(seconds: 20)) ;
          }
          TollFatka(name, price);
        }
      });

      if (_isMounted) {
        // Check if the widget is still mounted.
        setState(() {
          nearestLocation = nearest;
          nearestLocation_distance = minDistance;
        });
      }

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ),
        );
      }
    });

    setState(() {
      loaded = true;
    });
  }

  void initMarker(data, dataId) async {
    var lat = data['latitude'].toString();
    var long = data['longitude'].toString();
    var markerIdVal = data['name'].toString();
    var name = data['name'].toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(lat), double.parse(long)),
      infoWindow: InfoWindow(title: name),
    );
    setState(() {
      markers.add(marker);
    });
  }

  void addTemporaryMarker(LatLng latLng) {
    markers
        .removeWhere((marker) => marker.markerId.value == 'current_location');
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: latLng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  void updateMarkerIcon(String markerIdValue, BitmapDescriptor newIcon) {
    // Find the marker with the specified MarkerId
    Marker? targetMarker = markers.firstWhere(
      (marker) => marker.markerId.value == markerIdValue,
    );

    if (targetMarker != null) {
      // Create a new marker with updated properties
      Marker updatedMarker = targetMarker.copyWith(
        iconParam: newIcon,
      );

      // Update the set with the new marker
      markers = markers
          .where((marker) => marker.markerId.value != markerIdValue)
          .toSet()
        ..add(updatedMarker);
    }
    setState(() {
      // Ensure that the changes are reflected in the UI
      markers;
    });
  }

  void TollFatka(String name, double price) {
    // Query for the document with the specified  ;user ID
    _firestore.collection('Users').doc(user!.uid).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Document found, use its reference to add a collection
          DocumentReference docRef = documentSnapshot.reference;

          // Add a collection to the document
          docRef.collection('challan').add({
            'timestamp': FieldValue.serverTimestamp(),
            'price': price,
            'name': name,
            'paid': false
            // Add other fields as needed
          }).then(
            (value) {
              print('Collection added to document with name $name');
            },
          ).catchError(
            (error) {
              print('Error adding collection: $error');
            },
          );
        } else {
          print(
              'Document not found for user ID ${UserProvider().getuser()!.uid}');
        }
      },
    ).catchError(
      (error) {
        print('Error querying for document: $error');
      },
    );
  }
}

class StyledContainer extends StatelessWidget {
  final Widget child;

  StyledContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
