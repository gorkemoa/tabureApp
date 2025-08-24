import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/discovery_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../models/swipe.dart';
import '../widgets/user_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser == null) {
        authProvider.initialize();
      }
      
      final discoveryProvider = context.read<DiscoveryProvider>();
      discoveryProvider.loadUsers();
    });
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _showSwipeLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlük Limit'),
        content: const Text(
          'Günlük swipe limitinizi tamamladınız. Premium\'a geçin veya yarın tekrar deneyin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Premium sayfasına yönlendir
            },
            child: const Text('Premium'),
          ),
        ],
      ),
    );
  }

  void _showMatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Eşleşme!'),
        content: const Text(
          'Yeni bir eşleşmeniz var! Mesajlaşma başlayabilir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Devam Et'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Matches sayfasına yönlendir
            },
            child: const Text('Mesajlaş'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Keşfet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<DiscoveryProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.tune),
                    if (provider.selectedCity != null ||
                        provider.selectedProfession != null ||
                        provider.selectedLookingFor != null ||
                        provider.selectedExperienceLevel != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: _showFilters,
              );
            },
          ),
        ],
      ),
      body: Consumer<DiscoveryProvider>(
        builder: (context, discoveryProvider, child) {
          if (discoveryProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (discoveryProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    discoveryProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => discoveryProvider.loadUsers(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (!discoveryProvider.hasMoreUsers) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gösterilecek kişi kalmadı',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Filtreleri değiştirin veya daha sonra tekrar deneyin',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: _showFilters,
                        child: const Text('Filtreleri Değiştir'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: () => discoveryProvider.loadUsers(),
                        child: const Text('Yenile'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Swipe counter
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kalan: ${discoveryProvider.remainingSwipes}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // User card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: UserCard(
                    user: discoveryProvider.currentUser!,
                    onSwipe: (action) async {
                      if (!discoveryProvider.canSwipe) {
                        _showSwipeLimitDialog();
                        return;
                      }

                      final isMatch = await discoveryProvider.swipeUser(action);
                      
                      if (isMatch) {
                        _showMatchDialog();
                      }
                    },
                  ),
                ),
              ),
              
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pass button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: discoveryProvider.canSwipe
                            ? () => discoveryProvider.swipeUser(SwipeAction.pass)
                            : _showSwipeLimitDialog,
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                      ),
                    ),
                    
                    // Like button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: IconButton(
                        onPressed: discoveryProvider.canSwipe
                            ? () async {
                                final isMatch = await discoveryProvider.swipeUser(SwipeAction.like);
                                if (isMatch) {
                                  _showMatchDialog();
                                }
                              }
                            : _showSwipeLimitDialog,
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
