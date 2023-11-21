import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/snackbar.dart';

class DeleteTollPage extends StatefulWidget {
  const DeleteTollPage({Key? key});

  @override
  _DeleteTollPageState createState() => _DeleteTollPageState();
}

class _DeleteTollPageState extends State<DeleteTollPage> {
  TextEditingController _tollNameController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this toll?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the toll here, update _isTollDeleted accordingly
                deleteToll(context, _tollNameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Toll'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tollNameController,
              decoration: InputDecoration(labelText: 'Toll Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteToll(BuildContext context, String tollName) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await _firestore
        .collection('Tolls')
        .where('name', isEqualTo: tollName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there's only one document with the given Toll Name
      final documentId = querySnapshot.docs[0].id;

      await _firestore.collection('Tolls').doc(documentId).delete();
      showCustomSnackBar(context, "Toll Deleted");
    } else {
      showCustomSnackBar(context, "Sorry no Toll found with this Name");
    }
  }
}
