import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Screen imports
import '../screens/shared/splash_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/customer/customer_home.dart'; // Fixed import
import '../screens/customer/property_detail.dart'; // Fixed import
import '../screens/customer/contact_owner_screen.dart';
import '../screens/customer/lease_management.dart'; // Fixed import
import '../screens/owner/owner_dashboard.dart'; // Fixed import
import '../screens/owner/add_property_screen.dart';
import '../screens/owner/edit_property_screen.dart';
import '../screens/owner/inquiries_screen.dart';
import '../screens/shared/profile_screen.dart';
import '../screens/shared/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  static final initialRoute = splash;

  static void configureRoutes() {
    Get.config(
      enableLog: true,
      defaultTransition: Transition.fadeIn,
      defaultDuration: const Duration(milliseconds: 250),
    );
  }

  // Route names
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String signup = '/signup';

  // Owner routes
  static const String ownerDashboard = '/owner/dashboard';
  static const String addProperty = '/owner/add-property';
  static const String editProperty = '/owner/edit-property';
  static const String inquiries = '/owner/inquiries';

  // Customer routes
  static const String customerHome = '/customer/home';
  static const String propertyDetail = '/customer/property-detail';
  static const String contactOwner = '/customer/contact-owner';
  static const String leaseManagement = '/customer/lease-management';

  // Shared routes
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      middlewares: [_authMiddleware()],
    ),
    GetPage(
      name: roleSelection,
      page: () => const RoleSelectionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),

    // Owner routes
    GetPage(name: ownerDashboard, page: () => const OwnerDashboardScreen()),
    GetPage(name: addProperty, page: () => const AddPropertyScreen()),
    GetPage(name: editProperty, page: () => const EditPropertyScreen()),
    GetPage(name: inquiries, page: () => const InquiriesScreen()),

    // Customer routes
    GetPage(
      name: customerHome,
      page: () => const CustomerHomeScreen(),
    ),
    GetPage(
      name: propertyDetail,
      page: () => const PropertyDetailScreen(),
      arguments: {'propertyId': null},
      middlewares: [_validatePropertyMiddleware()],
    ),
    GetPage(
      name: contactOwner,
      page: () => const ContactOwnerScreen(),
      arguments: {'ownerId': null, 'propertyId': null},
      middlewares: [_validateOwnerMiddleware()],
    ),
    GetPage(name: leaseManagement, page: () => const LeaseManagementScreen()),

    // Shared routes
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];

  // Middleware factories
  static GetMiddleware _authMiddleware() {
    return GetMiddleware(
      priority: 1,
      redirect: (String? route) async {
        await Future.delayed(const Duration(milliseconds: 500));
        // Add auth check logic here
        return null;
      },
    );
  }

  static GetMiddleware _validatePropertyMiddleware() {
    return GetMiddleware(
      priority: 2,
      redirect: (String? route) {
        final args = Get.arguments as Map<String, dynamic>?;
        final propertyId = args?['propertyId'] as String?;
        if (propertyId == null || propertyId.isEmpty) {
          return customerHome;
        }
        return null;
      },
    );
  }

  static GetMiddleware _validateOwnerMiddleware() {
    return GetMiddleware(
      priority: 2,
      redirect: (String? route) {
        final args = Get.arguments as Map<String, dynamic>?;
        final ownerId = args?['ownerId'] as String?;
        if (ownerId == null || ownerId.isEmpty) {
          return customerHome;
        }
        return null;
      },
    );
  }

  // Navigation helpers
  static Future<T?> goToPage<T>(String route, {dynamic arguments}) async {
    try {
      return await Get.toNamed<T>(
        route,
        arguments: arguments,
        preventDuplicates: true,
      );
    } catch (e) {
      handleError('Navigation failed: $e');
      return null;
    }
  }

  static Future<T?> goToPropertyDetail<T>(String propertyId) async {
    try {
      if (propertyId.isEmpty) throw 'Invalid property ID';
      return await Get.toNamed<T>(
        propertyDetail,
        arguments: {'propertyId': propertyId},
        preventDuplicates: true,
      );
    } catch (e) {
      handleError('Failed to navigate: $e');
      return null;
    }
  }

  static Future<T?> goToContactOwner<T>(String ownerId, {String? propertyId}) async {
    try {
      if (ownerId.isEmpty) throw 'Invalid owner ID';
      return await Get.toNamed<T>(
        contactOwner,
        arguments: {
          'ownerId': ownerId,
          if (propertyId?.isNotEmpty ?? false) 'propertyId': propertyId,
        },
        preventDuplicates: true,
      );
    } catch (e) {
      handleError('Failed to navigate: $e');
      return null;
    }
  }

  static void goBackOrHome() {
    try {
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        Get.offAllNamed(customerHome);
      }
    } catch (e) {
      handleError('Navigation error: $e');
      Get.offAllNamed(customerHome);
    }
  }

  static void goBack<T>({T? result}) {
    try {
      if (Get.isDialogOpen ?? false) {
        Get.back<T>(result: result);
      } else if (Get.previousRoute.isNotEmpty) {
        Get.back<T>(result: result);
      }
    } catch (e) {
      handleError('Navigation error: $e');
    }
  }

  // Error handling with logging
  static void handleError(
    String message, {
    String? title,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
  }) {
    try {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      debugPrint('AppRoutes Error: $message'); // Add logging

      Get.snackbar(
        title ?? 'Error',
        message,
        snackPosition: position,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: duration ?? const Duration(seconds: 3),
        isDismissible: true,
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
        snackStyle: SnackStyle.FLOATING,
        mainButton: TextButton(
          onPressed: () => Get.closeCurrentSnackbar(),
          child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      debugPrint('Failed to show error: $e');
    }
  }

  // Error page
  static final GetPage unknownRoute = GetPage(
    name: '/404',
    page: () => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: BackButton(onPressed: () => Get.offAllNamed(customerHome)),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('The requested page was not found'),
          ],
        ),
      ),
    ),
  );
}