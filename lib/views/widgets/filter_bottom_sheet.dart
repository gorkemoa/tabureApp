import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/discovery_provider.dart';
import '../../services/discovery_service.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCity;
  String? _selectedProfession;
  String? _selectedLookingFor;
  String? _selectedExperienceLevel;

  @override
  void initState() {
    super.initState();
    final discoveryProvider = context.read<DiscoveryProvider>();
    _selectedCity = discoveryProvider.selectedCity;
    _selectedProfession = discoveryProvider.selectedProfession;
    _selectedLookingFor = discoveryProvider.selectedLookingFor;
    _selectedExperienceLevel = discoveryProvider.selectedExperienceLevel;
  }

  void _applyFilters() {
    final discoveryProvider = context.read<DiscoveryProvider>();
    discoveryProvider.setFilters(
      city: _selectedCity,
      profession: _selectedProfession,
      lookingFor: _selectedLookingFor,
      experienceLevel: _selectedExperienceLevel,
    );
    discoveryProvider.loadUsers();
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedCity = null;
      _selectedProfession = null;
      _selectedLookingFor = null;
      _selectedExperienceLevel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtreler',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Temizle'),
                      ),
                    ],
                  ),
                ),
                
                // Filters
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // City filter
                      _buildFilterSection(
                        'Şehir',
                        DropdownButtonFormField<String>(
                          value: _selectedCity,
                          decoration: InputDecoration(
                            hintText: 'Şehir seçin',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Tümü'),
                            ),
                            ...DiscoveryService.cities.map((city) => 
                              DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Profession filter
                      _buildFilterSection(
                        'Meslek',
                        DropdownButtonFormField<String>(
                          value: _selectedProfession,
                          decoration: InputDecoration(
                            hintText: 'Meslek seçin',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Tümü'),
                            ),
                            ...DiscoveryService.professionCategories.map((profession) => 
                              DropdownMenuItem(
                                value: profession,
                                child: Text(profession),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedProfession = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Looking for filter
                      _buildFilterSection(
                        'Aradığı şey',
                        DropdownButtonFormField<String>(
                          value: _selectedLookingFor,
                          decoration: InputDecoration(
                            hintText: 'Aradığı şeyi seçin',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Tümü'),
                            ),
                            ...DiscoveryService.lookingForOptions.map((option) => 
                              DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedLookingFor = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Experience level filter
                      _buildFilterSection(
                        'Deneyim Seviyesi',
                        DropdownButtonFormField<String>(
                          value: _selectedExperienceLevel,
                          decoration: InputDecoration(
                            hintText: 'Deneyim seviyesi seçin',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Tümü'),
                            ),
                            ...DiscoveryService.experienceLevels.map((level) => 
                              DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedExperienceLevel = value;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                
                // Apply button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _applyFilters,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Filtreleri Uygula',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
