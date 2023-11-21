import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class LocationMonitor extends StatefulWidget {
  @override
  _LocationMonitorState createState() => _LocationMonitorState();
}

class _LocationMonitorState extends State<LocationMonitor> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Geolocator _geolocator = Geolocator();
  final double thresholdDistance = 50.0;
  final Duration checkInterval = const Duration(minutes: 20);
  bool loaded = false;
  Position? _position;

  bool _isMounted = false;

  GoogleMapController? _mapController;
  Set<Marker> markers = <Marker>{};

  Map<String, Map<String, double>> monitoredLocations = {};
  Map<String, DateTime> lastCheckTimes = {};
  String nearestLocation = "";

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
    return (loaded)
        ? GoogleMap(
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

        monitoredLocations[name] = {
          'latitude': latitude,
          'longitude': longitude,
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

      _position = position;
      addTemporaryMarker(LatLng(position.latitude, position.longitude));
      monitoredLocations.forEach((name, coordinates) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          coordinates['latitude']!,
          coordinates['longitude']!,
        );

        print(distance);
        print("distance");
        if (distance < minDistance) {
          minDistance = distance;
          nearest = name;
        }

        if (distance <= thresholdDistance &&
            DateTime.now().difference(lastCheckTimes[name]!) >= checkInterval) {
          // Send payment link when within 50 meters
          double price = 100;

          lastCheckTimes[name] = DateTime.now();
        }
      });

      if (_isMounted) {
        // Check if the widget is still mounted.
        setState(() {
          nearestLocation = nearest;
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
}
