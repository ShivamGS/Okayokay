import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toll_system_final0/Admin/crud.dart/add_locations.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import 'crud.dart/delete.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  State<AdminMap> createState() => AdminMapState();
}

class AdminMapState extends State<AdminMap> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // late Position _position;
  late CameraPosition _kGooglePlex;
  Set<Marker> markers = <Marker>{};
  Set<Circle> circles = <Circle>{};
  bool loaded = false;
  LatLng? _toadd;

  @override
  void initState() {
    // TODO: implement initState
    getallMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (loaded)
          ? Scaffold(
              body: GoogleMap(
                markers: markers,
                circles: circles,
                onTap: (latlang) {
                  // _toadd = latlang;
                  addTemporaryMarker(latlang);
                },
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(markers.first.position.latitude,
                      markers.first.position.longitude),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddLocation(
                            markedLocation: _toadd,
                          ),
                        ),
                      );
                    },
                    label: const Text('Add Coordinates!'),
                    icon: const Icon(Icons.directions_boat),
                  ),
                  SizedBox(height: 16), // Add spacing
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeleteTollPage(), // Create DeletePage
                        ),
                      );
                    },
                    label: const Text('Delete Markers'),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
              heightFactor: 100,
              widthFactor: 100,
            ),
    );
  }

  // functions

  void getallMarkers() async {
    await _firestore
        .collection('Tolls')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        initMarker(doc.data(), doc.id);
      });
    });
    setState(() {
      loaded = true;
    });
  }

  void initMarker(data, dataId) async {
    var lat = data['latitude'].toString();
    var long = data['longitude'].toString();
    var markerIdVal = data['name'].toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(lat), double.parse(long)),
      infoWindow: InfoWindow(title: data['name']),
    );
    setState(() {
      markers.add(marker);
    });
  }

  void addTemporaryMarker(LatLng latLng) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('temporary_marker'),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      _toadd = latLng;
    });
  }
}
