import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'package:toll_system_final0/Admin/Widgets/text_form_field.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({required this.markedLocation});

  final LatLng? markedLocation;

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _tollname = TextEditingController();
  final TextEditingController _latitude = TextEditingController();
  final TextEditingController _longitude = TextEditingController();
  final TextEditingController _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values based on markedLocation
    if (widget.markedLocation != null) {
      _latitude.text = widget.markedLocation!.latitude.toString();
      _longitude.text = widget.markedLocation!.longitude.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  MyTextFormField(controller: _latitude, labelText: "Latitude"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextFormField(
                  controller: _longitude, labelText: "Longitude"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextFormField(
                  controller: _tollname, labelText: "Toll Name"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextFormField(controller: _price, labelText: "Price"),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_latitude.text == "" ||
                      _longitude.text == "" ||
                      _tollname.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Enter value properly"),
                    ));
                  } else {
                    addlocation(context);
                  }
                },
                child: Container(
                  child: Text("Submit"),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> addlocation(BuildContext context) async {
    // Store the coordinates in Firebase.
    var res = await _firestore.collection('Tolls').add({
      'latitude': _latitude.text,
      'longitude': _longitude.text,
      'name': _tollname.text,
      'price': _price.text
    });

    if (res.id != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Uploaded"),
      ));
      _latitude.clear();
      _longitude.clear();
      _price.clear();
      _tollname.clear();
    }
  }
}
