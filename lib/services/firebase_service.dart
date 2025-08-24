import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as app_user;
import '../models/event.dart';
import '../models/match.dart';
import '../models/message.dart';
import '../models/swipe.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _matchesCollection => _firestore.collection('matches');
  CollectionReference get _messagesCollection => _firestore.collection('messages');
  CollectionReference get _swipesCollection => _firestore.collection('swipes');

  Future<void> initializeWithMockData() async {
    // Sadece test amaçlı, gerçek uygulamada bu verileri admin panel'den eklersiniz
    await _addMockUsers();
    await _addMockEvents();
  }

  Future<void> _addMockUsers() async {
    final mockUsers = [
      app_user.User(
        id: 'user1',
        email: 'ahmet.yilmaz@example.com',
        firstName: 'Ahmet',
        lastName: 'Yılmaz',
        profession: 'Senior Flutter Developer',
        company: 'TechCorp',
        skills: ['Flutter', 'Dart', 'Mobile Development', 'Firebase', 'REST API'],
        lookingFor: 'iş ortağı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
        city: 'İstanbul',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/ahmetyilmaz',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      app_user.User(
        id: 'user2',
        email: 'ayse.demir@example.com',
        firstName: 'Ayşe',
        lastName: 'Demir',
        profession: 'Product Manager',
        company: 'StartupX',
        skills: ['Product Management', 'Scrum', 'Analytics', 'User Research', 'A/B Testing'],
        lookingFor: 'mentor',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b5b8?w=400&h=400&fit=crop&crop=face',
        city: 'İstanbul',
        experienceLevel: 'junior',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      app_user.User(
        id: 'user3',
        email: 'mehmet.kaya@example.com',
        firstName: 'Mehmet',
        lastName: 'Kaya',
        profession: 'Senior UI/UX Designer',
        company: 'DesignStudio',
        skills: ['Figma', 'Adobe XD', 'User Research', 'Prototyping', 'Design Systems'],
        lookingFor: 'freelance müşteri',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
        city: 'Ankara',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/mehmetkaya',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      app_user.User(
        id: 'user4',
        email: 'fatma.ozkan@example.com',
        firstName: 'Fatma',
        lastName: 'Özkan',
        profession: 'Digital Marketing Specialist',
        company: 'MarketingPro',
        skills: ['Digital Marketing', 'Social Media', 'Content Strategy', 'SEO', 'Google Ads'],
        lookingFor: 'sosyal bağlantı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400&h=400&fit=crop&crop=face',
        city: 'İzmir',
        experienceLevel: 'junior',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      app_user.User(
        id: 'user5',
        email: 'ali.vural@example.com',
        firstName: 'Ali',
        lastName: 'Vural',
        profession: 'Tech Entrepreneur',
        company: 'VuralTech',
        skills: ['Business Development', 'Startup', 'Investment', 'Leadership', 'Strategy'],
        lookingFor: 'yatırımcı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&h=400&fit=crop&crop=face',
        city: 'İstanbul',
        experienceLevel: 'girişimci',
        linkedinProfile: 'linkedin.com/in/alivural',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      app_user.User(
        id: 'user6',
        email: 'zeynep.aksoy@example.com',
        firstName: 'Zeynep',
        lastName: 'Aksoy',
        profession: 'Data Scientist',
        company: 'DataCorp',
        skills: ['Python', 'Machine Learning', 'SQL', 'Tableau', 'Statistics'],
        lookingFor: 'iş fırsatı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face',
        city: 'İstanbul',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/zeynepaksoy',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      app_user.User(
        id: 'user7',
        email: 'can.demir@example.com',
        firstName: 'Can',
        lastName: 'Demir',
        profession: 'Backend Developer',
        company: 'CodeFactory',
        skills: ['Node.js', 'MongoDB', 'Docker', 'AWS', 'Microservices'],
        lookingFor: 'iş ortağı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop&crop=face',
        city: 'Ankara',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/candemir',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      app_user.User(
        id: 'user8',
        email: 'selin.kara@example.com',
        firstName: 'Selin',
        lastName: 'Kara',
        profession: 'Business Analyst',
        company: 'ConsultingPlus',
        skills: ['Business Analysis', 'SQL', 'Power BI', 'Process Improvement', 'Agile'],
        lookingFor: 'mentor',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&h=400&fit=crop&crop=face',
        city: 'İzmir',
        experienceLevel: 'junior',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      app_user.User(
        id: 'user9',
        email: 'emre.yildiz@example.com',
        firstName: 'Emre',
        lastName: 'Yıldız',
        profession: 'DevOps Engineer',
        company: 'CloudTech',
        skills: ['Kubernetes', 'Jenkins', 'Terraform', 'Linux', 'CI/CD'],
        lookingFor: 'sosyal bağlantı',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=400&h=400&fit=crop&crop=face',
        city: 'İstanbul',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/emreyildiz',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastActive: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      app_user.User(
        id: 'user10',
        email: 'irem.sonmez@example.com',
        firstName: 'İrem',
        lastName: 'Sönmez',
        profession: 'Sales Manager',
        company: 'SalesPro',
        skills: ['B2B Sales', 'CRM', 'Lead Generation', 'Negotiation', 'Team Management'],
        lookingFor: 'freelance müşteri',
        profilePhotoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop&crop=face',
        city: 'Bursa',
        experienceLevel: 'senior',
        linkedinProfile: 'linkedin.com/in/iremsonmez',
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        lastActive: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    for (var user in mockUsers) {
      await _usersCollection.doc(user.id).set(user.toJson());
    }
  }

  Future<void> _addMockEvents() async {
    final mockEvents = [
      Event(
        id: 'event1',
        title: 'Startup Istanbul 2024',
        description: 'Türkiye\'nin en büyük startup ekosistemi etkinliği. Girişimciler, yatırımcılar ve teknoloji liderleri bir araya geliyor.',
        location: 'İstanbul Kongre Merkezi',
        city: 'İstanbul',
        date: DateTime.now().add(const Duration(days: 15)),
        category: 'Startup',
        participantIds: ['user1', 'user2', 'user5', 'user6'],
        organizer: 'Startup Istanbul',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
        maxParticipants: 500,
      ),
      Event(
        id: 'event2',
        title: 'Flutter Turkey Meetup #15',
        description: 'Flutter geliştiricileri için networking etkinliği. En son Flutter güncellemeleri ve best practice\'ler.',
        location: 'TechHub Istanbul',
        city: 'İstanbul',
        date: DateTime.now().add(const Duration(days: 7)),
        category: 'Technology',
        participantIds: ['user1', 'user3', 'user7'],
        organizer: 'Flutter Turkey',
        imageUrl: 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=300&fit=crop',
        maxParticipants: 50,
      ),
      Event(
        id: 'event3',
        title: 'Digital Marketing Summit 2024',
        description: 'Dijital pazarlama trendleri ve stratejileri. SEO, SEM, Social Media ve Content Marketing.',
        location: 'Ankara Hilton',
        city: 'Ankara',
        date: DateTime.now().add(const Duration(days: 20)),
        category: 'Marketing',
        participantIds: ['user4', 'user8'],
        organizer: 'Marketing Turkey',
        imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=300&fit=crop',
        maxParticipants: 200,
      ),
      Event(
        id: 'event4',
        title: 'UX/UI Design Workshop',
        description: 'Kullanıcı deneyimi ve arayüz tasarımı workshop\'u. Hands-on projeler ve case study\'ler.',
        location: 'Design Center İzmir',
        city: 'İzmir',
        date: DateTime.now().add(const Duration(days: 12)),
        category: 'Design',
        participantIds: ['user3', 'user4', 'user8'],
        organizer: 'Design Community İzmir',
        imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=400&h=300&fit=crop',
        maxParticipants: 30,
      ),
      Event(
        id: 'event5',
        title: 'Data Science & AI Conference',
        description: 'Veri bilimi ve yapay zeka konferansı. Machine Learning, Deep Learning ve Big Data.',
        location: 'Bilkent Kongre Merkezi',
        city: 'Ankara',
        date: DateTime.now().add(const Duration(days: 25)),
        category: 'Technology',
        participantIds: ['user6', 'user9'],
        organizer: 'Data Science Turkey',
        imageUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=300&fit=crop',
        maxParticipants: 300,
      ),
      Event(
        id: 'event6',
        title: 'Women in Tech Networking',
        description: 'Teknoloji sektöründeki kadınlar için networking etkinliği. Kariyer gelişimi ve mentorlük.',
        location: 'İTÜ Teknokent',
        city: 'İstanbul',
        date: DateTime.now().add(const Duration(days: 10)),
        category: 'Networking',
        participantIds: ['user2', 'user4', 'user6', 'user8'],
        organizer: 'Women in Tech Turkey',
        imageUrl: 'https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=400&h=300&fit=crop',
        maxParticipants: 100,
      ),
    ];

    for (var event in mockEvents) {
      await _eventsCollection.doc(event.id).set(event.toJson());
    }
  }

  // User operations
  Future<List<app_user.User>> getDiscoverUsers({
    String? currentUserId,
    String? city,
    String? profession,
    String? lookingFor,
    String? experienceLevel,
  }) async {
    Query query = _usersCollection;

    if (currentUserId != null) {
      query = query.where(FieldPath.documentId, isNotEqualTo: currentUserId);
    }
    
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    
    if (profession != null) {
      query = query.where('profession', isEqualTo: profession);
    }
    
    if (lookingFor != null) {
      query = query.where('lookingFor', isEqualTo: lookingFor);
    }
    
    if (experienceLevel != null) {
      query = query.where('experienceLevel', isEqualTo: experienceLevel);
    }

    query = query.limit(20);

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => 
      app_user.User.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id})
    ).toList();
  }

  Future<app_user.User?> getUserById(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (doc.exists) {
      return app_user.User.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
    }
    return null;
  }

  Future<void> saveUser(app_user.User user) async {
    await _usersCollection.doc(user.id).set(user.toJson());
  }

  // Event operations
  Future<List<Event>> getEvents({String? city}) async {
    Query query = _eventsCollection.where('isActive', isEqualTo: true);
    
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    
    query = query.orderBy('date');

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => 
      Event.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id})
    ).toList();
  }

  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      await _eventsCollection.doc(eventId).update({
        'participantIds': FieldValue.arrayUnion([userId])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<app_user.User>> getEventParticipants(String eventId, String? currentUserId) async {
    final eventDoc = await _eventsCollection.doc(eventId).get();
    if (!eventDoc.exists) return [];

    final event = Event.fromJson({...eventDoc.data() as Map<String, dynamic>, 'id': eventDoc.id});
    final participantIds = event.participantIds.where((id) => id != currentUserId).toList();

    if (participantIds.isEmpty) return [];

    final participants = <app_user.User>[];
    for (String participantId in participantIds) {
      final user = await getUserById(participantId);
      if (user != null) {
        participants.add(user);
      }
    }

    return participants;
  }

  // Swipe operations
  Future<void> saveSwipe(Swipe swipe) async {
    await _swipesCollection.doc(swipe.id).set(swipe.toJson());
  }

  Future<bool> hasSwipedUser(String swiperId, String swipedUserId) async {
    final querySnapshot = await _swipesCollection
        .where('swiperId', isEqualTo: swiperId)
        .where('swipedUserId', isEqualTo: swipedUserId)
        .get();
    
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> checkForMatch(String user1Id, String user2Id) async {
    final querySnapshot = await _swipesCollection
        .where('swiperId', isEqualTo: user2Id)
        .where('swipedUserId', isEqualTo: user1Id)
        .where('action', isEqualTo: 'like')
        .get();
    
    return querySnapshot.docs.isNotEmpty;
  }

  // Match operations
  Future<void> createMatch(Match match) async {
    await _matchesCollection.doc(match.id).set(match.toJson());
  }

  Future<List<Match>> getMatches(String userId) async {
    final querySnapshot = await _matchesCollection
        .where('isActive', isEqualTo: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => Match.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .where((match) => match.user1Id == userId || match.user2Id == userId)
        .toList();
  }

  // Message operations
  Future<List<Message>> getMessages(String matchId) async {
    final querySnapshot = await _messagesCollection
        .where('matchId', isEqualTo: matchId)
        .orderBy('sentAt')
        .get();
    
    return querySnapshot.docs.map((doc) => 
      Message.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id})
    ).toList();
  }

  Future<void> sendMessage(Message message) async {
    await _messagesCollection.doc(message.id).set(message.toJson());
    
    // Update match last message time
    await _matchesCollection.doc(message.matchId).update({
      'lastMessageAt': message.sentAt.toIso8601String(),
    });
  }
}
