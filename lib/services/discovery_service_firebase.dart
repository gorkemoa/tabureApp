import '../models/user.dart';
import '../models/swipe.dart';
import '../models/match.dart';
import 'firebase_service.dart';
import 'package:uuid/uuid.dart';

class DiscoveryService {
  static final DiscoveryService _instance = DiscoveryService._internal();
  factory DiscoveryService() => _instance;
  DiscoveryService._internal();

  final FirebaseService _firebaseService = FirebaseService();
  final Uuid _uuid = const Uuid();

  Future<List<User>> getDiscoverUsers({
    String? currentUserId,
    String? city,
    String? profession,
    String? lookingFor,
    String? experienceLevel,
  }) async {
    final users = await _firebaseService.getDiscoverUsers(
      currentUserId: currentUserId,
      city: city,
      profession: profession,
      lookingFor: lookingFor,
      experienceLevel: experienceLevel,
    );

    // Daha önce swipe yapılmış kullanıcıları filtrele
    final filteredUsers = <User>[];
    for (final user in users) {
      if (currentUserId != null) {
        final hasSwipped = await _firebaseService.hasSwipedUser(currentUserId, user.id);
        if (!hasSwipped) {
          filteredUsers.add(user);
        }
      } else {
        filteredUsers.add(user);
      }
    }

    return filteredUsers;
  }

  Future<bool> swipeUser(String swiperId, String userId, SwipeAction action) async {
    // Swipe'ı kaydet
    final swipe = Swipe(
      id: _uuid.v4(),
      swiperId: swiperId,
      swipedUserId: userId,
      action: action,
      swipedAt: DateTime.now(),
    );

    await _firebaseService.saveSwipe(swipe);

    // Eğer like ise, match kontrolü yap
    if (action == SwipeAction.like) {
      final isMatch = await _firebaseService.checkForMatch(swiperId, userId);
      
      if (isMatch) {
        // Match oluştur
        final match = Match(
          id: _uuid.v4(),
          user1Id: swiperId,
          user2Id: userId,
          matchedAt: DateTime.now(),
        );
        
        await _firebaseService.createMatch(match);
        return true; // Match!
      }
    }

    return false; // No match
  }

  // Predefined options for filters
  static const List<String> professionCategories = [
    'Software Developer',
    'Product Manager',
    'UI/UX Designer',
    'Marketing Specialist',
    'Sales Manager',
    'Data Scientist',
    'Entrepreneur',
    'Consultant',
    'Project Manager',
    'Business Analyst',
    'DevOps Engineer',
    'Backend Developer',
    'Frontend Developer',
    'Mobile Developer',
    'Tech Lead',
    'CTO',
    'CEO',
    'Founder',
  ];

  static const List<String> lookingForOptions = [
    'iş ortağı',
    'mentor',
    'yatırımcı',
    'freelance müşteri',
    'iş fırsatı',
    'sosyal bağlantı',
  ];

  static const List<String> experienceLevels = [
    'öğrenci',
    'junior',
    'senior',
    'girişimci',
  ];

  static const List<String> cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Adana',
    'Konya',
    'Gaziantep',
    'Kayseri',
    'Eskişehir',
  ];
}
