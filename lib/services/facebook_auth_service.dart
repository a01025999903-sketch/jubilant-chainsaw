import '../models/models.dart';

class FacebookAuthService {
  AuthenticatedUser? _currentUser;

  AuthenticatedUser? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<AuthenticatedUser?> signIn() async {
    // Meta OAuth integration will be added when real
    // Facebook App credentials and approved permissions are available.
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
  }
}
