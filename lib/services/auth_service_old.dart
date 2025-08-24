import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as app_user;
import 'mock_api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final MockApiService _mockApi = MockApiService();
  
  app_user.User? _currentAppUser;
  User? _currentFirebaseUser;

  static const String _userIdKey = 'current_user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> initialize() async {
    await _mockApi.initialize();
    
    // Firebase Auth state listener
    _firebaseAuth.authStateChanges().listen((User? user) {
      _currentFirebaseUser = user;
      if (user == null) {
        _currentAppUser = null;
      }
    });
    
    await _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final userId = prefs.getString(_userIdKey);

    if (isLoggedIn && userId != null) {
      _currentAppUser = await _mockApi.getUserById(userId);
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      // Firebase Authentication
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Mock API'den kullanıcı bilgilerini al
        final user = await _mockApi.signInWithEmail(email, password);
        if (user != null) {
          _currentAppUser = user;
          await _saveUserSession(user.id);
          return true;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      // Firebase'de kullanıcı yoksa mock API'yi dene
      final user = await _mockApi.signInWithEmail(email, password);
      if (user != null) {
        _currentAppUser = user;
        await _saveUserSession(user.id);
        return true;
      }
      return false;
    } catch (e) {
      print('Auth Error: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      // Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase Authentication
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Mock API'de kullanıcı oluştur veya al
        final user = await _mockApi.signInWithGoogle();
        if (user != null) {
          _currentAppUser = user;
          await _saveUserSession(user.id);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Google Sign In Error: $e');
      return false;
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
    try {
      // Firebase Authentication
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Kullanıcı profilini güncelle
        await credential.user!.updateDisplayName('$firstName $lastName');
        
        // Mock API'de kullanıcı oluştur
        final user = await _mockApi.signUp(
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
        
        _currentAppUser = user;
        await _saveUserSession(user.id);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      return false;
    } catch (e) {
      print('Sign Up Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _mockApi.signOut();
      _currentAppUser = null;
      _currentFirebaseUser = null;
      await _clearUserSession();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  Future<void> _saveUserSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
  }

  Future<void> _clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
  }

  // Getters
  app_user.User? get currentUser => _currentAppUser;
  User? get currentFirebaseUser => _currentFirebaseUser;
  bool get isLoggedIn => _currentAppUser != null;
}
