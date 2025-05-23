// filepath: c:\Desktop\rent\lib\screens\shared\profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';

class ProfileController extends GetxController {
  final RxString name = 'John Smith'.obs;
  final RxString email = 'john.smith@example.com'.obs;
  final RxString phone = '+1 (555) 123-4567'.obs;
  final RxBool isOwner = true.obs;
  final RxString profileImage = 'assets/images/placeholder.png'.obs;
  
  // Stats
  final RxInt propertiesOwned = 3.obs;
  final RxInt propertiesRented = 0.obs;
  final RxInt favorites = 5.obs;
  final RxInt reviews = 7.obs;
  
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    if (name != null) this.name.value = name;
    if (email != null) this.email.value = email;
    if (phone != null) this.phone.value = phone;
    if (profileImage != null) this.profileImage.value = profileImage;
    
    Get.snackbar(
      'Profile Updated',
      'Your profile has been updated successfully!',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void logout() {
    // In a real app, this would handle authentication logout
    Get.offAllNamed('/role-selection');
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(controller),
            const SizedBox(height: 24),
            _buildStatsSection(controller),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(controller),
            const SizedBox(height: 24),
            _buildActionsSection(controller),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader(ProfileController controller) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Obx(() => CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(controller.profileImage.value),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      // In a real app, this would open image picker
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.name.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.isOwner.value ? 'Property Owner' : 'Tenant',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildStatsSection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            controller.isOwner.value 
                ? 'Properties' 
                : 'Rented',
            controller.isOwner.value 
                ? controller.propertiesOwned.toString() 
                : controller.propertiesRented.toString(),
            Icons.home,
          ),
          _buildStatItem(
            'Favorites',
            controller.favorites.toString(),
            Icons.favorite,
          ),
          _buildStatItem(
            'Reviews',
            controller.reviews.toString(),
            Icons.star,
          ),
        ],
      )),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
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
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPersonalInfoSection(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoItem(
          'Name',
          controller.name.value,
          Icons.person,
          onTap: () => _showEditDialog(
            'Edit Name',
            'Name',
            controller.name.value,
            (value) => controller.updateProfile(name: value),
          ),
        ),
        const Divider(),
        _buildInfoItem(
          'Email',
          controller.email.value,
          Icons.email,
          onTap: () => _showEditDialog(
            'Edit Email',
            'Email',
            controller.email.value,
            (value) => controller.updateProfile(email: value),
          ),
        ),
        const Divider(),
        _buildInfoItem(
          'Phone',
          controller.phone.value,
          Icons.phone,
          onTap: () => _showEditDialog(
            'Edit Phone',
            'Phone',
            controller.phone.value,
            (value) => controller.updateProfile(phone: value),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionsSection(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Security'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.payments_outlined),
          title: const Text('Payment Methods'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.red.shade400,
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: Colors.red.shade400,
            ),
          ),
          onTap: () => _showLogoutDialog(controller),
        ),
      ],
    );
  }
  
  void _showEditDialog(
    String title,
    String label,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);
    
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(ProfileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

