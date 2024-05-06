import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users.dart' as model;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: Image(
          image: NetworkImage(user.photoUrl),
        ),
      ),
    );
  }
}
