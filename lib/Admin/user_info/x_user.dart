import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserCard extends StatelessWidget {
  // const UserCard({super.key});
  final DocumentSnapshot<Object?> user;

  UserCard({super.key, required this.user});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['firstName']),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Total Amount to pay: ${user['Money to pay']}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Name:- "),
                Text(user['firstName']),
                Text(" "),
                Text(user['lastName']),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text("Vehicle number:- "),
                Text(user['vehicleNumber'])
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text("Mobile number:- "), Text(user['mobileNumber'])],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Text("Toll History"),
          ),
          // Expanded(
          //   child: StreamBuilder(
          //       stream: _firestore
          //           .collection("Users")
          //           .doc(user.id)
          //           .collection("Toll Info")
          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         if (!snapshot.hasData) {
          //           return Center(child: Text("No data"));
          //         } else {
          //           return DataTable(
          //             columns: const <DataColumn>[
          //               DataColumn(label: Text('Date')),
          //               DataColumn(label: Text('Time')),
          //               DataColumn(label: Text('Paid Status')),
          //             ],
          //             rows: snapshot.data!.docs.map((doc) {
          //               Timestamp timestamp = doc["Time"];
          //               DateTime dateTime = timestamp.toDate();
          //               String formattedDate =
          //                   DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
          //               bool isPaid = doc["Paid"];

          //               return DataRow(
          //                 cells: [
          //                   DataCell(Text(formattedDate.substring(0, 10))),
          //                   DataCell(
          //                       Text(DateFormat('HH:mm').format(dateTime))),
          //                   DataCell(Text(isPaid ? 'Paid' : 'Not Paid')),
          //                 ],
          //               );
          //             }).toList(),
          //           );
          //         }
          //       }),
          // ),
        ]),
      ),
    );
  }
}
