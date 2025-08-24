import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/auth_provider.dart';
import '../../services/discovery_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _companyController = TextEditingController();
  final _linkedinController = TextEditingController();
  
  // Form data
  final List<String> _skills = [];
  String? _selectedLookingFor;
  String? _selectedCity;
  String? _selectedExperienceLevel;
  
  int _currentPage = 0;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _companyController.dispose();
    _linkedinController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _isFormComplete()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        profession: _professionController.text.trim(),
        company: _companyController.text.trim(),
        skills: _skills,
        lookingFor: _selectedLookingFor!,
        profilePhotoUrl: 'https://randomuser.me/api/portraits/men/20.jpg', // Mock foto
        city: _selectedCity!,
        experienceLevel: _selectedExperienceLevel!,
        linkedinProfile: _linkedinController.text.trim().isNotEmpty 
            ? _linkedinController.text.trim() 
            : null,
      );

      if (success && mounted) {
        context.go('/home');
      }
    }
  }

  bool _isFormComplete() {
    return _selectedLookingFor != null &&
           _selectedCity != null &&
           _selectedExperienceLevel != null &&
           _skills.isNotEmpty;
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
        title: Text('${_currentPage + 1}/3'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            _buildBasicInfoPage(),
            _buildProfessionalInfoPage(),
            _buildPreferencesPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kişisel Bilgiler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hesabınızı oluşturmak için temel bilgilerinizi girin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _firstNameController,
            validator: (value) => value?.isEmpty == true ? 'Ad gerekli' : null,
            decoration: InputDecoration(
              labelText: 'Ad',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _lastNameController,
            validator: (value) => value?.isEmpty == true ? 'Soyad gerekli' : null,
            decoration: InputDecoration(
              labelText: 'Soyad',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty == true) return 'Email gerekli';
              if (value?.contains('@') != true) return 'Geçerli email girin';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value?.isEmpty == true) return 'Şifre gerekli';
              if ((value?.length ?? 0) < 6) return 'En az 6 karakter';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Şifre',
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          const Spacer(),
          
          FilledButton(
            onPressed: () {
              if (_firstNameController.text.isNotEmpty &&
                  _lastNameController.text.isNotEmpty &&
                  _emailController.text.contains('@') &&
                  _passwordController.text.length >= 6) {
                _nextPage();
              }
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Profesyonel Bilgiler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kariyeriniz hakkında bilgi verin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _professionController,
            validator: (value) => value?.isEmpty == true ? 'Meslek gerekli' : null,
            decoration: InputDecoration(
              labelText: 'Meslek/Pozisyon',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _companyController,
            validator: (value) => value?.isEmpty == true ? 'Şirket/Okul gerekli' : null,
            decoration: InputDecoration(
              labelText: 'Şirket/Okul',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _linkedinController,
            decoration: InputDecoration(
              labelText: 'LinkedIn Profili (Opsiyonel)',
              hintText: 'linkedin.com/in/kullaniciadi',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Beceriler',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skills.map((skill) => Chip(
                    label: Text(skill),
                    onDeleted: () => _removeSkill(skill),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  )).toList(),
                ),
                if (_skills.isEmpty)
                  Text(
                    'Henüz beceri eklenmedi',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Beceri ekle...',
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    _addSkill(value.trim());
                  },
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          FilledButton(
            onPressed: () {
              if (_professionController.text.isNotEmpty &&
                  _companyController.text.isNotEmpty &&
                  _skills.isNotEmpty) {
                _nextPage();
              }
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tercihler',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aradığınızı ve konumunuzu belirtin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          DropdownButtonFormField<String>(
            value: _selectedLookingFor,
            decoration: InputDecoration(
              labelText: 'Ne arıyorsunuz?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: DiscoveryService.lookingForOptions.map((option) => 
              DropdownMenuItem(value: option, child: Text(option))
            ).toList(),
            onChanged: (value) => setState(() => _selectedLookingFor = value),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: InputDecoration(
              labelText: 'Şehir',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: DiscoveryService.cities.map((city) => 
              DropdownMenuItem(value: city, child: Text(city))
            ).toList(),
            onChanged: (value) => setState(() => _selectedCity = value),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedExperienceLevel,
            decoration: InputDecoration(
              labelText: 'Deneyim Seviyesi',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: DiscoveryService.experienceLevels.map((level) => 
              DropdownMenuItem(value: level, child: Text(level))
            ).toList(),
            onChanged: (value) => setState(() => _selectedExperienceLevel = value),
          ),
          
          const Spacer(),
          
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return FilledButton(
                onPressed: authProvider.isLoading || !_isFormComplete() ? null : _signUp,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Hesap Oluştur'),
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Zaten hesabınız var mı? ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
