import '../../data/models/user_model.dart';

class SessionManager {
  // Singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void saveSession(UserModel user) {
    _currentUser = user;
  }

  void clearSession() {
    _currentUser = null;
  }
}
