import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/property_model.dart';
import '../../routes/app_routes.dart';
import '../../core/widgets/property_card.dart';
import '../../core/widgets/property_feature.dart';
import '../../core/widgets/property_tag.dart';
import '../../core/widgets/empty_state.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  
  // Filter values
  RangeValues _priceRange = const RangeValues(500, 5000);
  int _minBedrooms = 0;
  List<String> _selectedAmenities = [];
  
  // Fix RxDart declarations
  final RxBool _isLoading = false.obs;
  final RxList<Property> _properties = <Property>[].obs;
  final RxString _searchQuery = ''.obs;
  
  final List<String> _recentSearches = [
    'Downtown apartments',
    'Houses with pool',
    '2 bedrooms near park',
  ];
  
  final List<String> _popularLocations = [
    'Downtown',
    'Westside',
    'Riverfront',
    'Uptown',
    'Beachside',
    'Metro Area',
  ];

  @override
  void initState() {
    super.initState();
    // Fix initialization timing
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProperties());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      _properties.value = Property.getSampleProperties();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _applyFilters(PropertyFilter filter) {
    try {
      _isLoading.value = true;
      final filtered = _properties.where((p) => p.matchesFilter(filter)).toList();
      _properties.assignAll(filtered);
    } catch (e) {
      AppRoutes.handleError('Failed to apply filters');
    } finally {
      _isLoading.value = false;
    }
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiSizes.cardRadius),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => _buildFilterBottomSheet(setState),
      ),
    );
  }
  
  void _navigateToPropertyDetail(String propertyId) {
    Navigator.of(context).pushNamed(
      AppRoutes.propertyDetail,
      arguments: {'propertyId': propertyId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _selectedIndex == 0 ? _buildHomeAppBar() : _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavigationItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  AppBar _buildHomeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'New York, USA',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
          },
        ),
      ],
    );
  }
  
  AppBar _buildAppBar() {
    switch (_selectedIndex) {
      case 1: // Search
        return AppBar(
          title: const Text('Search'),
          centerTitle: false,
        );
      case 2: // Saved
        return AppBar(
          title: const Text('Saved Properties'),
          centerTitle: false,
        );
      case 3: // Profile
        return AppBar(
          title: const Text('My Profile'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),
          ],
        );
      default:
        return AppBar(
          title: const Text('RentEase'),
          centerTitle: false,
        );
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildSearchTab();
      case 2:
        return _buildSavedTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(UiSizes.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for properties...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.primary,
                  ),
                  onPressed: _showFilterBottomSheet,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: UiSizes.spacing),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentSearches.length,
                itemBuilder: (context, index) {                  return Container(
                    margin: const EdgeInsets.only(right: UiSizes.spacing),
                    child: InkWell(
                      onTap: () {
                        _searchController.text = _recentSearches[index];
                        // Focus on search tab
                        setState(() {
                          _selectedIndex = 1; // Switch to search tab
                        });
                      },
                      borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSizes.spacingLarge,
                          vertical: UiSizes.spacing,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _recentSearches[index],
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: UiSizes.spacingXLarge),
          ],
            // Popular locations
          Text(
            'Popular Locations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UiSizes.spacing),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _popularLocations.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: UiSizes.spacingLarge),
                  child: Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Filter properties by location
                            _searchController.text = _popularLocations[index];
                            setState(() {
                              _selectedIndex = 1; // Switch to search tab
                            });
                          },
                          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/location_${index + 1}.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: UiSizes.spacing),
                      Text(
                        _popularLocations[index],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Featured properties
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Properties',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all featured properties
                  setState(() {
                    _selectedIndex = 1; // Switch to search tab
                  });
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: UiSizes.spacing),
          
          if (_properties.isEmpty)
            const EmptyState(
              icon: Icons.home_outlined,
              title: 'No Properties Found',
              message: 'Try adjusting your search filters',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _properties.length > 3 ? 3 : _properties.length, // Limit to 3 on homepage
              itemBuilder: (context, index) {
                final property = _properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () => _navigateToPropertyDetail(property.id),
                );
              },
            ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Recommendations
          Text(
            'Recommended for You',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UiSizes.spacing),
          
          // In a real app, these would be different properties based on user preferences
          if (_properties.isEmpty)
            const EmptyState(
              icon: Icons.home_outlined,
              title: 'No Properties Found',
              message: 'Try adjusting your search filters',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _properties.length > 3 ? 3 : _properties.length, // Limit to 3 on homepage
              itemBuilder: (context, index) {
                final property = _properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () => _navigateToPropertyDetail(property.id),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(UiSizes.spacingLarge),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for properties...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: UiSizes.spacing),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white),
                  onPressed: _showFilterBottomSheet,
                ),
              ),
            ],
          ),
        ),
        
        // Property list
        Expanded(
          child: _properties.isEmpty
              ? const EmptyState(
                  icon: Icons.home_outlined,
                  title: 'No Properties Found',
                  message: 'Try adjusting your search filters',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(UiSizes.spacingLarge),
                  itemCount: _properties.length,
                  itemBuilder: (context, index) {
                    final property = _properties[index];
                    return PropertyCard(
                      property: property,
                      onTap: () => _navigateToPropertyDetail(property.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSavedTab() {
    return Center(
      child: Text(
        'No saved properties yet',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Text(
        'Profile tab content',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildFilterBottomSheet(StateSetter setState) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(UiSizes.spacingXLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Properties',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Reset filters
                        setState(() {
                          _priceRange = const RangeValues(500, 5000);
                          _minBedrooms = 0;
                          _selectedAmenities = [];
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: UiSizes.spacingXLarge),
                
                // Price range
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: UiSizes.spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_priceRange.start.toInt()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '\$${_priceRange.end.toInt()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary.withOpacity(0.2),
                  labels: RangeLabels(
                    '\$${_priceRange.start.toInt()}',
                    '\$${_priceRange.end.toInt()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: UiSizes.spacingXLarge),
                
                // Bedrooms
                Text(
                  'Bedrooms',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: UiSizes.spacingLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    // index 0 = Any (0+), index 1 = 1+, etc.
                    final bedrooms = index;
                    final isSelected = _minBedrooms == bedrooms;
                    final label = index == 0 ? 'Any' : '$bedrooms+';
                    
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _minBedrooms = bedrooms;
                        });
                      },
                      borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSizes.spacingLarge,
                          vertical: UiSizes.spacing,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: UiSizes.spacingXLarge),
                  // Amenities
                Text(
                  'Amenities',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: UiSizes.spacingLarge),
                Wrap(
                  spacing: UiSizes.spacing,
                  runSpacing: UiSizes.spacing,
                  children: [
                    for (final amenity in PropertyAmenities.getAllAmenities())
                      FilterChip(
                        label: Text(amenity),
                        selected: _selectedAmenities.contains(amenity),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        backgroundColor: Colors.white,                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(UiSizes.cardRadius / 2),
                          side: BorderSide(
                            color: AppColors.textLight.withOpacity(0.3),
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: _selectedAmenities.contains(amenity)
                              ? AppColors.primary
                              : AppColors.textMedium,
                        ),
                        showCheckmark: true,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSizes.spacing, 
                          vertical: UiSizes.spacing / 2,
                        ),
                      ),
                  ],
                ),                const SizedBox(height: UiSizes.spacingXXLarge),
                
                // Apply button
                SizedBox(
                  width: double.infinity,
                  height: UiSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters and close sheet
                      Navigator.of(context).pop();
                      
                      // Apply filters to property list
                      _loadProperties();
                      
                      // Show a feedback snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Filters applied'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                          ),
                          action: SnackBarAction(
                            label: 'DISMISS',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

