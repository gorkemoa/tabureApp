import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/swipe.dart';
import '../services/discovery_service.dart';

class DiscoveryProvider extends ChangeNotifier {
  final DiscoveryService _discoveryService = DiscoveryService();
  
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentIndex = 0;
  
  // Filters
  String? _selectedCity;
  String? _selectedProfession;
  String? _selectedLookingFor;
  String? _selectedExperienceLevel;

  // Daily swipe limit
  static const int dailySwipeLimit = 10;
  int _dailySwipeCount = 0;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentIndex => _currentIndex;
  User? get currentUser => _currentIndex < _users.length ? _users[_currentIndex] : null;
  bool get hasMoreUsers => _currentIndex < _users.length;
  bool get canSwipe => _dailySwipeCount < dailySwipeLimit;
  int get remainingSwipes => dailySwipeLimit - _dailySwipeCount;

  // Filters getters
  String? get selectedCity => _selectedCity;
  String? get selectedProfession => _selectedProfession;
  String? get selectedLookingFor => _selectedLookingFor;
  String? get selectedExperienceLevel => _selectedExperienceLevel;

  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();
    
    try {
      final users = await _discoveryService.getDiscoverUsers(
        city: _selectedCity,
        profession: _selectedProfession,
        lookingFor: _selectedLookingFor,
        experienceLevel: _selectedExperienceLevel,
      );
      
      _users = users;
      _currentIndex = 0;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load users: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> swipeUser(SwipeAction action) async {
    if (!canSwipe || currentUser == null) return false;
    
    try {
      final isMatch = await _discoveryService.swipeUser(currentUser!.id, action);
      _dailySwipeCount++;
      _moveToNextUser();
      
      // If no more users, load more
      if (!hasMoreUsers) {
        await loadUsers();
      }
      
      return isMatch;
    } catch (e) {
      _setError('Swipe failed: $e');
      return false;
    }
  }

  void _moveToNextUser() {
    if (_currentIndex < _users.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = _users.length; // No more users
    }
    notifyListeners();
  }

  void setFilters({
    String? city,
    String? profession,
    String? lookingFor,
    String? experienceLevel,
  }) {
    _selectedCity = city;
    _selectedProfession = profession;
    _selectedLookingFor = lookingFor;
    _selectedExperienceLevel = experienceLevel;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCity = null;
    _selectedProfession = null;
    _selectedLookingFor = null;
    _selectedExperienceLevel = null;
    notifyListeners();
  }

  void resetDailySwipeCount() {
    _dailySwipeCount = 0;
    notifyListeners();
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
