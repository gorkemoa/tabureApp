import '../models/user.dart';
import '../models/swipe.dart';
import 'mock_api_service.dart';

class DiscoveryService {
  static final DiscoveryService _instance = DiscoveryService._internal();
  factory DiscoveryService() => _instance;
  DiscoveryService._internal();

  final MockApiService _mockApi = MockApiService();

  Future<List<User>> getDiscoverUsers({
    String? city,
    String? profession,
    String? lookingFor,
    String? experienceLevel,
  }) async {
    return await _mockApi.getDiscoverUsers(
      city: city,
      profession: profession,
      lookingFor: lookingFor,
      experienceLevel: experienceLevel,
    );
  }

  Future<bool> swipeUser(String userId, SwipeAction action) async {
    return await _mockApi.swipeUser(userId, action);
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
