import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/property_model.dart';
import '../../routes/app_routes.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late PageController _imagePageController;
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  
  // Sample property data (in real app, this would come from a database or API)
  late Property property;
  
  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    
    // Initialize with sample data
    property = Property(
      id: '1',
      ownerId: 'owner1',
      title: 'Modern Downtown Apartment',
      description: 'Beautiful modern apartment in the heart of downtown. Featuring floor-to-ceiling windows with stunning city views, hardwood floors throughout, and a recently renovated kitchen with stainless steel appliances. The building offers 24/7 security, a gym, and a rooftop pool. Walking distance to restaurants, shopping, and public transportation.',
      price: 2500,
      address: '123 Main St, Downtown, New York',
      images: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        'https://images.unsplash.com/photo-1560448204-603b3fc33ddc',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb',
      ],
      bedrooms: 2,
      bathrooms: 2,
      area: 1200,
      amenities: [
        PropertyAmenities.wifi,
        PropertyAmenities.ac,
        PropertyAmenities.gym,
        PropertyAmenities.parking,
        PropertyAmenities.pool,
        PropertyAmenities.laundry,
      ],
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      leaseTerms: LeaseTerms(
        minDuration: 6,
        maxDuration: 24,
        isPetFriendly: true,
        includesUtilities: false,
        securityDeposit: 2500,
        additionalConditions: [
          'No smoking',
          'Background check required',
          'Income verification required',
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }
  
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite 
              ? 'Property added to favorites' 
              : 'Property removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to favorites
          },
        ),
      ),
    );
  }
  
  void _navigateToContactOwner() {
    Navigator.of(context).pushNamed(
      AppRoutes.contactOwner,
      arguments: {'propertyId': property.id, 'ownerId': property.ownerId},
    );
  }
  
  void _showLeaseDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiSizes.cardRadius),
        ),
      ),
      builder: (context) => _buildLeaseBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Property content
          CustomScrollView(
            slivers: [
              // App bar with image carousel
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite 
                            ? Icons.favorite 
                            : Icons.favorite_outline,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Share property
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image carousel
                      PageView.builder(
                        controller: _imagePageController,
                        itemCount: property.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            property.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      
                      // Image counter indicator
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1}/${property.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      // Image dots indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            property.images.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentImageIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Property details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(UiSizes.spacingXLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.title,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: AppColors.textLight,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        property.address,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${property.price.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'per month',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: UiSizes.spacingXLarge),
                      
                      // Property features
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeatureItem(
                            Icons.king_bed_outlined,
                            '${property.bedrooms} ${property.bedrooms == 1 ? 'Bedroom' : 'Bedrooms'}',
                          ),
                          _buildFeatureItem(
                            Icons.bathtub_outlined,
                            '${property.bathrooms} ${property.bathrooms == 1 ? 'Bathroom' : 'Bathrooms'}',
                          ),
                          _buildFeatureItem(
                            Icons.square_foot,
                            '${property.area.toStringAsFixed(0)} ft²',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: UiSizes.spacingXLarge),
                      const Divider(),
                      const SizedBox(height: UiSizes.spacingLarge),
                      
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: UiSizes.spacingLarge),
                      Text(
                        property.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: UiSizes.spacingXLarge),
                      
                      // Amenities
                      Text(
                        'Amenities',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: UiSizes.spacingLarge),
                      Wrap(
                        spacing: UiSizes.spacingLarge,
                        runSpacing: UiSizes.spacingLarge,
                        children: property.amenities.map((amenity) {
                          IconData icon;
                          
                          // Determine icon based on amenity
                          switch (amenity) {
                            case PropertyAmenities.wifi:
                              icon = Icons.wifi;
                              break;
                            case PropertyAmenities.ac:
                              icon = Icons.ac_unit;
                              break;
                            case PropertyAmenities.heating:
                              icon = Icons.heat_pump_outlined;
                              break;
                            case PropertyAmenities.laundry:
                              icon = Icons.local_laundry_service_outlined;
                              break;
                            case PropertyAmenities.parking:
                              icon = Icons.local_parking_outlined;
                              break;
                            case PropertyAmenities.pool:
                              icon = Icons.pool_outlined;
                              break;
                            case PropertyAmenities.gym:
                              icon = Icons.fitness_center_outlined;
                              break;
                            case PropertyAmenities.petFriendly:
                              icon = Icons.pets_outlined;
                              break;
                            default:
                              icon = Icons.check_circle_outline;
                          }
                          
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - UiSizes.spacingXLarge * 1.5,
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    amenity,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: UiSizes.spacingXLarge),
                      
                      // Lease terms
                      Text(
                        'Lease Terms',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: UiSizes.spacingLarge),
                      _buildLeaseTermItem(
                        'Duration',
                        '${property.leaseTerms.minDuration} - ${property.leaseTerms.maxDuration} months',
                      ),
                      const SizedBox(height: UiSizes.spacing),
                      _buildLeaseTermItem(
                        'Security Deposit',
                        '\$${property.leaseTerms.securityDeposit.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: UiSizes.spacing),
                      _buildLeaseTermItem(
                        'Pet Policy',
                        property.leaseTerms.isPetFriendly ? 'Pet friendly' : 'No pets allowed',
                      ),
                      const SizedBox(height: UiSizes.spacing),
                      _buildLeaseTermItem(
                        'Utilities',
                        property.leaseTerms.includesUtilities ? 'Included in rent' : 'Not included',
                      ),
                      
                      if (property.leaseTerms.additionalConditions.isNotEmpty) ...[
                        const SizedBox(height: UiSizes.spacingLarge),
                        Text(
                          'Additional Conditions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: UiSizes.spacing),
                        ...property.leaseTerms.additionalConditions.map((condition) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.textMedium,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    condition,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      
                      const SizedBox(height: UiSizes.spacingXLarge),
                      
                      // Location
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: UiSizes.spacingLarge),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: AppColors.primary.withOpacity(0.1),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Map view would appear here',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Space for bottom bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(UiSizes.spacingLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _navigateToContactOwner,
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: UiSizes.spacingLarge),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showLeaseDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Lease Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildLeaseTermItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLeaseBottomSheet() {
    int leaseDuration = property.leaseTerms.minDuration;
    final pricePerMonth = property.price;
    
    return StatefulBuilder(
      builder: (context, setState) {
        final totalLeaseAmount = pricePerMonth * leaseDuration;
        final depositAmount = property.leaseTerms.securityDeposit;
        final firstMonthAmount = pricePerMonth;
        final totalInitialPayment = depositAmount + firstMonthAmount;
        
        return Container(
          padding: const EdgeInsets.all(UiSizes.spacingXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lease Agreement',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please select your preferred lease duration',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: UiSizes.spacingXLarge),
              
              // Lease duration slider
              Text(
                'Lease Duration: ${leaseDuration} months',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: UiSizes.spacingLarge),              Slider(
                value: leaseDuration.toDouble(),
                min: property.leaseTerms.minDuration.toDouble(),
                max: property.leaseTerms.maxDuration?.toDouble() ?? 24.0,
                divisions: (property.leaseTerms.maxDuration ?? 24) - property.leaseTerms.minDuration,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.2),
                onChanged: (value) {
                  setState(() {
                    leaseDuration = value.toInt();
                  });
                },
              ),
              
              const SizedBox(height: UiSizes.spacingXLarge),
              
              // Cost breakdown
              Text(
                'Cost Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: UiSizes.spacingLarge),
              _buildCostItem(
                'Monthly Rent',
                '\$${pricePerMonth.toStringAsFixed(0)}',
              ),
              const Divider(height: 24),
              _buildCostItem(
                'Security Deposit',
                '\$${depositAmount.toStringAsFixed(0)}',
              ),
              const Divider(height: 24),
              _buildCostItem(
                'First Month Rent',
                '\$${firstMonthAmount.toStringAsFixed(0)}',
              ),
              const Divider(height: 24),
              _buildCostItem(
                'Total Lease Amount',
                '\$${totalLeaseAmount.toStringAsFixed(0)}',
                subtext: 'Over $leaseDuration months',
              ),
              const Divider(height: 24),
              _buildCostItem(
                'Initial Payment',
                '\$${totalInitialPayment.toStringAsFixed(0)}',
                subtext: 'Due upon signing',
                isBold: true,
              ),
              
              const SizedBox(height: UiSizes.spacingXXLarge),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: UiSizes.spacingLarge),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Process lease request
                        Navigator.of(context).pop();
                        
                        // Show confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lease request submitted successfully!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        
                        // Navigate to lease management
                        Navigator.of(context).pushNamed(AppRoutes.leaseManagement);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Request Lease'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCostItem(String label, String amount, {String? subtext, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (subtext != null)
              Text(
                subtext,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
          ],
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}

