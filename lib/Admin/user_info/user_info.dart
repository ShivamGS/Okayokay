import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toll_system_final0/Admin/user_info/x_user.dart';

import '../Widgets/search_bar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    setState(() {});
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
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final userDoc = snapshot.data!.docs[index];
                          final vehicleNumber =
                              userDoc["vehicleNumber"].toString().toLowerCase();
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
    );
  }
}
