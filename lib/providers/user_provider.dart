import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_method.dart';

import '../models/users.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authmethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authmethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
