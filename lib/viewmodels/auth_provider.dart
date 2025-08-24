import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _currentUser = _authService.currentUser;
      _clearError();
    } catch (e) {
      _setError('Initialization failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.signInWithEmail(email, password);
      if (success) {
        _currentUser = _authService.currentUser;
        notifyListeners();
        return true;
      } else {
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      _setError('Sign in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        _currentUser = _authService.currentUser;
        notifyListeners();
        return true;
      } else {
        _setError('Google sign in failed');
        return false;
      }
    } catch (e) {
      _setError('Google sign in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String profession,
    required String company,
    required List<String> skills,
    required String lookingFor,
    required String profilePhotoUrl,
    required String city,
    required String experienceLevel,
    String? linkedinProfile,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        profession: profession,
        company: company,
        skills: skills,
        lookingFor: lookingFor,
        profilePhotoUrl: profilePhotoUrl,
        city: city,
        experienceLevel: experienceLevel,
        linkedinProfile: linkedinProfile,
      );
      
      if (success) {
        _currentUser = _authService.currentUser;
        notifyListeners();
        return true;
      } else {
        _setError('Sign up failed');
        return false;
      }
    } catch (e) {
      _setError('Sign up failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
