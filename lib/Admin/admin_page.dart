import 'package:flutter/material.dart';
import 'package:toll_system_final0/Admin/admin_map.dart';
import 'package:toll_system_final0/Admin/user_info/user_info.dart';

class AdminPage extends StatelessWidget {
  List Pages = [AdminMap(), UserInfo()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hellow"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      goto(0, context);
                    },
                    child: Container(
                      child: Text("Tolls"),
                    )),
                ElevatedButton(
                    onPressed: () {
                      goto(1, context);
                    },
                    child: Container(
                      child: Text("Users Information"),
                    ))
              ],
            ),
          ),
        ));
  }

  goto(int i, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pages[i]),
    );
  }
}
