import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Auth/provider/provider.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Center(child: Text(userProvider.getuser()!.uid));
  }
}
