import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/property_model.dart';
import '../../routes/app_routes.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Sample data (would normally come from a service/API)
  final List<Property> _properties = [];
  int get totalProperties => _properties.length;
  int get activeLeases => 5; // Sample value
  int get pendingInquiries => 8; // Sample value
  double get totalRevenue => 7500.0; // Sample value - monthly revenue

  @override
  void initState() {
    super.initState();
    // Fetch properties, inquiries, etc.
    _loadData();
  }

  void _loadData() {
    // Simulate loading data
    // In a real app, this would fetch from an API or database
    setState(() {
      // Sample properties would be loaded here
    });
  }

  void _navigateToAddProperty() {
    Navigator.of(context).pushNamed(AppRoutes.addProperty);
  }

  void _navigateToEditProperty(String propertyId) {
    Navigator.of(context).pushNamed(
      AppRoutes.editProperty,
      arguments: {'propertyId': propertyId},
    );
  }

  void _navigateToInquiries() {
    Navigator.of(context).pushNamed(AppRoutes.inquiries);
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Open notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.profile);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProperty,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavigationItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildPropertiesTab();
      case 2:
        return _buildMessagesTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UiSizes.spacingXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UiSizes.spacing),
          Text(
            'Here\'s what\'s happening with your properties',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: UiSizes.spacingXXLarge),
          
          // Stats cards
          Row(
            children: [
              _buildStatCard(
                context,
                'Properties', 
                totalProperties.toString(), 
                Icons.home_outlined,
                AppColors.primary,
              ),
              const SizedBox(width: UiSizes.spacing),
              _buildStatCard(
                context,
                'Active Leases', 
                activeLeases.toString(), 
                Icons.assignment_outlined,
                AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: UiSizes.spacing),
          Row(
            children: [
              _buildStatCard(
                context,
                'Inquiries', 
                pendingInquiries.toString(), 
                Icons.message_outlined,
                AppColors.accent,
              ),
              const SizedBox(width: UiSizes.spacing),
              _buildStatCard(
                context,
                'Revenue', 
                '\$${totalRevenue.toStringAsFixed(0)}', 
                Icons.attach_money,
                AppColors.secondary,
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingXXLarge),
          
          // Recent inquiries
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Inquiries',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: _navigateToInquiries,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          
          // Sample inquiries
          _buildInquiryItem(
            'John Doe', 
            'Interested in your Downtown Apartment...', 
            '2h ago',
            'Downtown Apartment',
          ),
          const Divider(),
          _buildInquiryItem(
            'Jane Smith', 
            'Is the Luxury Villa still available for...', 
            '5h ago',
            'Luxury Villa',
          ),
          const Divider(),
          _buildInquiryItem(
            'Alex Johnson', 
            'I would like to schedule a viewing for...', 
            '1d ago',
            'Modern Studio',
          ),
          
          const SizedBox(height: UiSizes.spacingXXLarge),
          
          // Quick actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          
          // Quick action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                'Add Property',
                Icons.add_home_outlined,
                _navigateToAddProperty,
              ),
              _buildQuickActionButton(
                'Messages',
                Icons.message_outlined,
                _navigateToInquiries,
              ),
              _buildQuickActionButton(
                'Leases',
                Icons.description_outlined,
                () {
                  // Navigate to leases screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab() {
    if (_properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 72,
              color: AppColors.textLight,
            ),
            const SizedBox(height: UiSizes.spacingLarge),
            Text(
              'No Properties Yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: UiSizes.spacing),
            Text(
              'Add your first property to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: UiSizes.spacingXLarge),
            ElevatedButton.icon(
              onPressed: _navigateToAddProperty,
              icon: const Icon(Icons.add),
              label: const Text('Add Property'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSizes.spacingXLarge,
                  vertical: UiSizes.spacingLarge,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      itemCount: _properties.length,
      itemBuilder: (context, index) {
        final property = _properties[index];
        return Card(
          margin: const EdgeInsets.only(bottom: UiSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(UiSizes.cardRadius),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: property.images.isNotEmpty
                      ? Image.network(
                          property.images.first,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.primary.withOpacity(0.1),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),
              
              // Property details
              Padding(
                padding: const EdgeInsets.all(UiSizes.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UiSizes.spacing,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: property.isAvailable
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            property.isAvailable ? 'Available' : 'Rented',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: property.isAvailable
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: UiSizes.spacing),
                    Text(
                      property.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: UiSizes.spacingLarge),
                    
                    // Property features
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPropertyFeature(
                          Icons.king_bed_outlined,
                          '${property.bedrooms} ${property.bedrooms == 1 ? 'Bed' : 'Beds'}',
                        ),
                        _buildPropertyFeature(
                          Icons.bathtub_outlined,
                          '${property.bathrooms} ${property.bathrooms == 1 ? 'Bath' : 'Baths'}',
                        ),
                        _buildPropertyFeature(
                          Icons.square_foot,
                          '${property.area.toStringAsFixed(0)} ft²',
                        ),
                        _buildPropertyFeature(
                          Icons.attach_money,
                          '\$${property.price.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: UiSizes.spacingLarge),
                    const Divider(),
                    const SizedBox(height: UiSizes.spacing),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPropertyActionButton(
                          'Edit',
                          Icons.edit_outlined,
                          () => _navigateToEditProperty(property.id),
                        ),
                        _buildPropertyActionButton(
                          'Inquiries',
                          Icons.message_outlined,
                          () {
                            // Navigate to property inquiries
                          },
                        ),
                        _buildPropertyActionButton(
                          property.isAvailable ? 'Mark Rented' : 'Mark Available',
                          property.isAvailable
                              ? Icons.home_outlined
                              : Icons.check_circle_outline,
                          () {
                            // Toggle availability
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesTab() {
    return Center(
      child: Text(
        'Messages tab content',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Text(
        'Settings tab content',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: UiSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(UiSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: UiSizes.spacing),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiSizes.spacingLarge),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInquiryItem(
    String name,
    String message,
    String time,
    String propertyName,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        radius: 24,
        child: Text(
          name.substring(0, 1),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Property: $propertyName',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to inquiry details
      },
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(UiSizes.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UiSizes.cardRadius),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: UiSizes.spacing),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyFeature(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textMedium,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: UiSizes.spacing,
          vertical: UiSizes.spacing / 2,
        ),
      ),
    );
  }
}

