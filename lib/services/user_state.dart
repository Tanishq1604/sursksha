import 'package:flutter/foundation.dart';
import '../Models/user_model.dart';

class UserState extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}

final userState = UserState();
