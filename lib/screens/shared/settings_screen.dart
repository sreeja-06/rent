// filepath: c:\Desktop\rent\lib\screens\shared\settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';

class SettingsController extends GetxController {
  // Theme settings
  final RxBool isDarkMode = false.obs;
  final RxInt selectedThemeColor = 0.obs;
  
  // Notification settings
  final RxBool enablePushNotifications = true.obs;
  final RxBool enableEmailNotifications = true.obs;
  final RxBool enableInAppNotifications = true.obs;
  
  // Privacy settings
  final RxBool shareLocationData = true.obs;
  final RxBool shareActivityData = false.obs;
  
  // App settings
  final RxString selectedLanguage = 'English'.obs;
  final RxString selectedCurrency = 'USD'.obs;
  
  // Cache data
  final RxDouble cacheSize = 24.5.obs; // In MB
  
  // Add loading state
  final isLoading = false.obs;

  final List<String> availableLanguages = [
    'English', 
    'Spanish', 
    'French', 
    'German', 
    'Chinese'
  ];
  
  final List<String> availableCurrencies = [
    'USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;
      // Mock loading settings
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    // UI-only implementation
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    saveSettings();
  }
  
  void togglePushNotifications(bool value) {
    enablePushNotifications.value = value;
    saveSettings();
  }
  
  void toggleEmailNotifications(bool value) {
    enableEmailNotifications.value = value;
    saveSettings();
  }
  
  void toggleInAppNotifications(bool value) {
    enableInAppNotifications.value = value;
    saveSettings();
  }
  
  void toggleShareLocationData(bool value) {
    shareLocationData.value = value;
    saveSettings();
  }
  
  void toggleShareActivityData(bool value) {
    shareActivityData.value = value;
    saveSettings();
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
    saveSettings();
  }
  
  void setCurrency(String currency) {
    selectedCurrency.value = currency;
    saveSettings();
  }

  void clearCache() {
    // Simulate clearing cache by setting value to 0
    cacheSize.value = 0.0;
  }
  
  Future<void> saveSettings() async {
    try {
      isLoading.value = true;
      // Save to storage in real app
      await Future.delayed(const Duration(milliseconds: 500));
      Get.snackbar(
        'Success',
        'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Display',
                children: [
                  _buildSwitchTile(
                    title: 'Dark Mode',
                    subtitle: 'Enable dark theme for the app',
                    icon: Icons.dark_mode_outlined,
                    value: controller.isDarkMode,
                    onChanged: controller.toggleDarkMode,
                  ),
                  _buildDivider(),
                  _buildColorThemeTile(context, controller),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                title: 'Notifications',
                children: [
                  _buildSwitchTile(
                    title: 'Push Notifications',
                    subtitle: 'Receive notifications on your device',
                    icon: Icons.notifications_outlined,
                    value: controller.enablePushNotifications,
                    onChanged: controller.togglePushNotifications,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Email Notifications',
                    subtitle: 'Receive notifications via email',
                    icon: Icons.email_outlined,
                    value: controller.enableEmailNotifications,
                    onChanged: controller.toggleEmailNotifications,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'In-App Notifications',
                    subtitle: 'Show alerts within the app',
                    icon: Icons.app_registration,
                    value: controller.enableInAppNotifications,
                    onChanged: controller.toggleInAppNotifications,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                title: 'Privacy',
                children: [
                  _buildSwitchTile(
                    title: 'Location Data',
                    subtitle: 'Share your location data to improve property recommendations',
                    icon: Icons.location_on_outlined,
                    value: controller.shareLocationData,
                    onChanged: controller.toggleShareLocationData,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Activity Data',
                    subtitle: 'Share your in-app activity for personalized experience',
                    icon: Icons.data_usage_outlined,
                    value: controller.shareActivityData,
                    onChanged: controller.toggleShareActivityData,
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    icon: Icons.policy_outlined,
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                title: 'App Settings',
                children: [
                  _buildDropdownTile(
                    title: 'Language',
                    icon: Icons.language_outlined,
                    value: controller.selectedLanguage,
                    items: controller.availableLanguages,
                    onChanged: (value) => controller.setLanguage(value),
                  ),
                  _buildDivider(),
                  _buildDropdownTile(
                    title: 'Currency',
                    icon: Icons.currency_exchange_outlined,
                    value: controller.selectedCurrency,
                    items: controller.availableCurrencies,
                    onChanged: (value) => controller.setCurrency(value),
                  ),
                ],
              ),
              const SizedBox(height: 20),
                _buildSection(
                title: 'Data & Storage',
                children: [
                  Obx(() => _buildActionTile(
                    title: 'Clear Cache',
                    subtitle: 'Current cache size: ${controller.cacheSize.value} MB',
                    icon: Icons.cleaning_services_outlined,
                    onTap: () => controller.clearCache(),
                  )),
                  _buildDivider(),
                  _buildActionTile(
                    title: 'Download Data',
                    subtitle: 'Download your personal data',
                    icon: Icons.download_outlined,
                    onTap: () => _showDownloadDataDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                title: 'About',
                children: [
                  _buildActionTile(
                    title: 'App Version',
                    subtitle: AppInfo.appVersion,
                    icon: Icons.info_outline,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    icon: Icons.description_outlined,
                    onTap: () => _showTermsOfService(context),
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: 'Contact Support',
                    subtitle: 'Get help with any issues',
                    icon: Icons.contact_support_outlined,
                    onTap: () => _showContactSupportDialog(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              Center(
                child: Text(
                  AppInfo.copyrightText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool value,
    required Function(bool) onChanged,
  }) {
    return Obx(() => ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ),
      trailing: Switch(
        value: value.value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    ));
  }
  
  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildDropdownTile<T>({
    required String title,
    required IconData icon,
    required Rx<T> value,
    required List<T> items,
    required Function(T) onChanged,
  }) {
    return Obx(() => ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value.value,
        underline: const SizedBox(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
      ),
    ));
  }
  
  Widget _buildColorThemeTile(BuildContext context, SettingsController controller) {
    final List<Color> themeColors = [
      AppColors.primary,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];
    
    return ListTile(
      leading: const Icon(
        Icons.color_lens_outlined,
        color: AppColors.primary,
      ),
      title: const Text('Theme Color'),
      subtitle: const Text(
        'Change the app accent color',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ),      trailing: Obx(() => SizedBox(
        width: 80,
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: themeColors.length,
          itemBuilder: (context, index) {
            return GestureDetector(              onTap: () {
                controller.selectedThemeColor.value = index;
                // Update theme color selection
                controller.saveSettings();
              },child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: themeColors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.selectedThemeColor.value == index 
                        ? Colors.white 
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    if (controller.selectedThemeColor.value == index)
                      BoxShadow(
                        color: themeColors[index].withOpacity(0.6),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: controller.selectedThemeColor.value == index
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
            );
          },
        ),
      )),
    );
  }
  
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 70,
      endIndent: 0,
    );
  }
  
  void _showPrivacyPolicy(BuildContext context) {    _showInfoDialog(
      context,
      'Privacy Policy',
      'This is a sample privacy policy for RentEase. This would contain information about how user data is collected, used, and protected.',
    );
  }
  
  void _showTermsOfService(BuildContext context) {    _showInfoDialog(
      context,
      'Terms of Service',
      'This is a sample terms of service for RentEase. This would contain information about the rules, guidelines, and legal agreements between the app and its users.',
    );
  }
    void _showContactSupportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactMethod(Icons.email_outlined, 'Email', 'support@rentease.com'),
            const SizedBox(height: 12),
            _buildContactMethod(Icons.phone_outlined, 'Phone', '+1 (800) 123-4567'),
            const SizedBox(height: 12),
            _buildContactMethod(Icons.chat_outlined, 'Live Chat', 'Available 24/7'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactMethod(IconData icon, String title, String detail) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              detail,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
  void _showDownloadDataDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'You can download all your personal data including properties, messages, and account information. The download will be prepared and sent to your registered email address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Request Data'),
          ),
        ],
      ),
    );
  }
  
  void _showInfoDialog(BuildContext context, String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

