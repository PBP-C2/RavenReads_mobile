import 'package:flutter/foundation.dart';
import 'package:raven_reads_mobile/models/User.dart';
class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(String username, int id) {
    _user = User(username: username, id: id);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}