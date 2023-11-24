import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toll_system_final0/Admin/tollCard.dart';

import 'Widgets/search_bar.dart';

class tollInfo extends StatefulWidget {
  const tollInfo({super.key});

  @override
  State<tollInfo> createState() => _tollInfoState();
}

class _tollInfoState extends State<tollInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 60, left: 15, right: 15),
          child: Column(
            children: [
              Searchbar(
                controller: _searchController,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore.collection("Tolls").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("No data"));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final userDoc = snapshot.data!.docs[index];
                            final vehicleNumber =
                                userDoc["name"].toString().toLowerCase();
                            final query = _searchController.text.toLowerCase();

                            if (vehicleNumber.contains(query)) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.white,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TollCard(user: userDoc),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(userDoc["name"] +
                                        " " +
                                        userDoc["price"]),
                                    subtitle: Text(userDoc["latitude"]
                                        .toString()
                                        .toUpperCase()),
                                  ),
                                ),
                              );
                            } else {
                              // Return an empty container if not matching the search
                              return Container();
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
