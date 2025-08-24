import '../models/user.dart';
import '../models/event.dart';
import '../models/match.dart';
import '../models/message.dart';
import '../models/swipe.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  // Mock data storage
  final List<User> _users = [];
  final List<Event> _events = [];
  final List<Match> _matches = [];
  final List<Message> _messages = [];
  final List<Swipe> _swipes = [];

  String? _currentUserId;

  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _generateMockData();
  }

  void _generateMockData() {
    // Mock users
    _users.addAll([
      User(
        id: '1',
        email: 'ahmet.yilmaz@example.com',
        firstName: 'Ahmet',
        lastName: 'Yılmaz',
        profession: 'Software Developer',
        company: 'TechCorp',
        skills: ['Flutter', 'Dart', 'Mobile Development'],
        lookingFor: 'iş ortağı',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        city: 'İstanbul',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/ahmetyilmaz',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      User(
        id: '2',
        email: 'ayse.demir@example.com',
        firstName: 'Ayşe',
        lastName: 'Demir',
        profession: 'Product Manager',
        company: 'StartupX',
        skills: ['Product Management', 'Scrum', 'Analytics'],
        lookingFor: 'mentor',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
        city: 'İstanbul',
        experienceLevel: 'junior',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      User(
        id: '3',
        email: 'mehmet.kaya@example.com',
        firstName: 'Mehmet',
        lastName: 'Kaya',
        profession: 'UI/UX Designer',
        company: 'DesignStudio',
        skills: ['Figma', 'Adobe XD', 'User Research'],
        lookingFor: 'freelance müşteri',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        city: 'Ankara',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/mehmetkaya',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      User(
        id: '4',
        email: 'fatma.ozkan@example.com',
        firstName: 'Fatma',
        lastName: 'Özkan',
        profession: 'Marketing Specialist',
        company: 'MarketingPro',
        skills: ['Digital Marketing', 'Social Media', 'Content Strategy'],
        lookingFor: 'sosyal bağlantı',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
        city: 'İzmir',
        experienceLevel: 'junior',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      User(
        id: '5',
        email: 'ali.vural@example.com',
        firstName: 'Ali',
        lastName: 'Vural',
        profession: 'Entrepreneur',
        company: 'VuralTech',
        skills: ['Business Development', 'Startup', 'Investment'],
        lookingFor: 'yatırımcı',
        profilePhotoUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
        city: 'İstanbul',
        experienceLevel: 'girişimci',
        linkedinProfile: 'linkedin.com/in/alivural',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);

    // Mock events
    _events.addAll([
      Event(
        id: '1',
        title: 'Startup Istanbul 2024',
        description: 'Türkiye\'nin en büyük startup ekosistemi etkinliği',
        location: 'İstanbul Kongre Merkezi',
        city: 'İstanbul',
        date: DateTime.now().add(const Duration(days: 15)),
        category: 'Startup',
        participantIds: ['1', '2', '5'],
        organizer: 'Startup Istanbul',
        imageUrl: 'https://via.placeholder.com/300x200?text=Startup+Istanbul',
        maxParticipants: 500,
      ),
      Event(
        id: '2',
        title: 'Flutter Turkey Meetup',
        description: 'Flutter geliştiricileri için networking etkinliği',
        location: 'TechHub Istanbul',
        city: 'İstanbul',
        date: DateTime.now().add(const Duration(days: 7)),
        category: 'Technology',
        participantIds: ['1', '3'],
        organizer: 'Flutter Turkey',
        imageUrl: 'https://via.placeholder.com/300x200?text=Flutter+Meetup',
        maxParticipants: 50,
      ),
      Event(
        id: '3',
        title: 'Digital Marketing Summit',
        description: 'Dijital pazarlama trendleri ve stratejileri',
        location: 'Ankara Hilton',
        city: 'Ankara',
        date: DateTime.now().add(const Duration(days: 20)),
        category: 'Marketing',
        participantIds: ['4'],
        organizer: 'Marketing Turkey',
        imageUrl: 'https://via.placeholder.com/300x200?text=Marketing+Summit',
        maxParticipants: 200,
      ),
    ]);
  }

  // Auth methods
  Future<User?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = _users.where((u) => u.email == email).firstOrNull;
    if (user != null) {
      _currentUserId = user.id;
      return user;
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock Google sign in
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: 'google.user@gmail.com',
      firstName: 'Google',
      lastName: 'User',
      profession: 'Developer',
      company: 'Google',
      skills: ['Android', 'iOS'],
      lookingFor: 'iş ortağı',
      profilePhotoUrl: 'https://randomuser.me/api/portraits/men/10.jpg',
      city: 'İstanbul',
      experienceLevel: 'senior',
      isVerified: true,
      createdAt: DateTime.now(),
    );
    
    _users.add(newUser);
    _currentUserId = newUser.id;
    return newUser;
  }

  Future<User> signUp({
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
    await Future.delayed(const Duration(seconds: 1));
    
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
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
      createdAt: DateTime.now(),
    );
    
    _users.add(newUser);
    _currentUserId = newUser.id;
    return newUser;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserId = null;
  }

  // User methods
  Future<List<User>> getDiscoverUsers({
    String? city,
    String? profession,
    String? lookingFor,
    String? experienceLevel,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_currentUserId == null) return [];
    
    var filteredUsers = _users.where((user) => 
      user.id != _currentUserId &&
      !_hasSwipedUser(user.id)
    ).toList();
    
    if (city != null) {
      filteredUsers = filteredUsers.where((u) => u.city == city).toList();
    }
    if (profession != null) {
      filteredUsers = filteredUsers.where((u) => u.profession.contains(profession)).toList();
    }
    if (lookingFor != null) {
      filteredUsers = filteredUsers.where((u) => u.lookingFor == lookingFor).toList();
    }
    if (experienceLevel != null) {
      filteredUsers = filteredUsers.where((u) => u.experienceLevel == experienceLevel).toList();
    }
    
    // Shuffle for variety
    filteredUsers.shuffle();
    return filteredUsers.take(10).toList();
  }

  bool _hasSwipedUser(String userId) {
    return _swipes.any((swipe) => 
      swipe.swiperId == _currentUserId && swipe.swipedUserId == userId
    );
  }

  Future<bool> swipeUser(String userId, SwipeAction action) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUserId == null) return false;
    
    final swipe = Swipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      swiperId: _currentUserId!,
      swipedUserId: userId,
      action: action,
      swipedAt: DateTime.now(),
    );
    
    _swipes.add(swipe);
    
    // Check for match
    if (action == SwipeAction.like) {
      final reverseSwipe = _swipes.where((s) => 
        s.swiperId == userId && 
        s.swipedUserId == _currentUserId && 
        s.action == SwipeAction.like
      ).firstOrNull;
      
      if (reverseSwipe != null) {
        // Create match
        final match = Match(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          user1Id: _currentUserId!,
          user2Id: userId,
          matchedAt: DateTime.now(),
        );
        _matches.add(match);
        return true; // It's a match!
      }
    }
    
    return false;
  }

  Future<List<Match>> getMatches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_currentUserId == null) return [];
    
    return _matches.where((match) => 
      match.user1Id == _currentUserId || match.user2Id == _currentUserId
    ).toList();
  }

  Future<User?> getUserById(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _users.where((u) => u.id == userId).firstOrNull;
  }

  // Event methods
  Future<List<Event>> getEvents({String? city}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    var filteredEvents = _events.where((event) => event.isActive).toList();
    
    if (city != null) {
      filteredEvents = filteredEvents.where((e) => e.city == city).toList();
    }
    
    return filteredEvents;
  }

  Future<bool> joinEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (_currentUserId == null) return false;
    
    final eventIndex = _events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) return false;
    
    final event = _events[eventIndex];
    if (event.isFull || event.participantIds.contains(_currentUserId)) {
      return false;
    }
    
    event.participantIds.add(_currentUserId!);
    return true;
  }

  Future<List<User>> getEventParticipants(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final event = _events.where((e) => e.id == eventId).firstOrNull;
    if (event == null) return [];
    
    return _users.where((user) => 
      event.participantIds.contains(user.id) && user.id != _currentUserId
    ).toList();
  }

  // Message methods
  Future<List<Message>> getMessages(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return _messages.where((msg) => msg.matchId == matchId)
        .toList()..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  Future<Message> sendMessage({
    required String matchId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUserId == null) throw Exception('Not authenticated');
    
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      matchId: matchId,
      senderId: _currentUserId!,
      content: content,
      type: type,
      sentAt: DateTime.now(),
    );
    
    _messages.add(message);
    
    // Update match last message time
    final matchIndex = _matches.indexWhere((m) => m.id == matchId);
    if (matchIndex != -1) {
      final match = _matches[matchIndex];
      _matches[matchIndex] = Match(
        id: match.id,
        user1Id: match.user1Id,
        user2Id: match.user2Id,
        matchedAt: match.matchedAt,
        lastMessageAt: DateTime.now(),
        isActive: match.isActive,
      );
    }
    
    return message;
  }

  // Current user
  String? get currentUserId => _currentUserId;
  
  Future<User?> getCurrentUser() async {
    if (_currentUserId == null) return null;
    return getUserById(_currentUserId!);
  }
}
