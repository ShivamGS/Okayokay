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
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.blue,
          //   ),
          //   child: Text(
          //     "Total Amount to Pay: ${user['Money to pay']}",
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Name: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "${user['firstName']} ${user['lastName']}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Vehicle Number: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  user['vehicleNumber'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Mobile Number: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  user['mobileNumber'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Toll History:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add your toll history widgets here

            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.id)
                    .collection('challan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No challan data available'),
                    );
                  }

                  // Extract and display three fields from each document in the 'challan' collection
                  List<Widget> challanWidgets =
                      snapshot.data!.docs.map((document) {
                    Map<String, dynamic> challanData =
                        document.data() as Map<String, dynamic>;
                    Timestamp timestamp = challanData['timestamp'];
                    String formattedDateTime =
                        DateFormat.yMd().add_Hms().format(timestamp.toDate());

                    return ListTile(
                      title: Text('Toll Name: ${challanData['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time/Day: ${challanData['field2']}'),
                          Text('price: ${challanData['price']}'),
                          Text('Timestamp: $formattedDateTime'),
                        ],
                      ),
                    );
                  }).toList();

                  return ListView(
                    children: challanWidgets,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
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
  }
}
