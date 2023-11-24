import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toll_system_final0/Admin/user_info/x_user.dart';

import '../Widgets/search_bar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() async {
    await _firestore.collection("Users").snapshots().forEach((element) {
      setState(() {
        _filteredData = element.docs.where((userDoc) {
          final vehicleNumber =
              userDoc["vehicleNumber"].toString().toLowerCase();
          final query = _searchController.text.toLowerCase();
          return vehicleNumber.contains(query);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 15, right: 15),
        child: Column(
          children: [
            Searchbar(
              controller: _searchController,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text("No data"));
                  } else {
                    final dataToDisplay = _filteredData.isNotEmpty
                        ? _filteredData
                        : snapshot.data!.docs;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: dataToDisplay.length,
                        itemBuilder: (context, index) {
                          final userDoc = dataToDisplay[index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 2.0), // Border color and width
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Circular border radius
                                  color: Colors.white, // Background color
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserCard(user: userDoc),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(userDoc["firstName"] +
                                        " " +
                                        userDoc["lastName"]),
                                    subtitle: Text(userDoc["vehicleNumber"]
                                        .toString()
                                        .toUpperCase()),
                                  ),
                                ),
                              ));
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
    );
  }
}
