// App info
class AppInfo {
  static const String appName = 'RentEase';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your all-in-one property rental solution';
  static const String copyrightText = '© 2024 RentEase. All rights reserved.';
}

// API endpoints and services
class ApiConstants {
  static const String baseUrl = 'https://api.rentease.com/v1';
  static const String authEndpoint = '/auth';
  static const String propertiesEndpoint = '/properties';
  static const String usersEndpoint = '/users';
  static const String leasesEndpoint = '/leases';
  static const String messagesEndpoint = '/messages';

  // Timeout durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}

// Local storage keys
class StorageKeys {
  static const String userToken = 'user_token';
  static const String userData = 'user_data';
  static const String userRole = 'user_role';
  static const String appTheme = 'app_theme';
  static const String recentSearches = 'recent_searches';
  static const String savedProperties = 'saved_properties';
  static const String lastLoginDate = 'last_login_date';
}

// Input validation rules
class ValidationRules {
  static const int minPasswordLength = 6;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 2000;
  static const double minRentPrice = 100;
  static const double maxRentPrice = 100000;
  static const int maxImageCount = 10;
  static const int maxAmenitiesCount = 20;
  
  static const String phoneRegex = r'^\+?[0-9]{10,15}$';
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$';
}

// Animation durations
class AnimationDurations {
  static const Duration shortest = Duration(milliseconds: 150);
  static const Duration short = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 700);
  static const Duration splash = Duration(milliseconds: 2500);
}

// UI sizing constants
class UiSizes {
  static const double buttonHeight = 48.0;
  static const double cardRadius = 12.0;
  static const double spacing = 8.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 60.0;
  static const double avatarSizeLarge = 80.0;
  static const double iconSize = 24.0;
}

// Error messages
class ErrorMessages {
  static const String noInternet = 'No internet connection. Please check your connection and try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authFailed = 'Authentication failed. Please check your credentials.';
  static const String sessionExpired = 'Your session has expired. Please login again.';
  static const String permissionDenied = 'You don\'t have permission to perform this action.';
  static const String invalidInput = 'Please check your input and try again.';
  static const String unknownError = 'Something went wrong. Please try again.';
}

// App routes constants (for deep linking)
class DeepLinkPaths {
  static const String propertyDetails = 'property';
  static const String ownerProfile = 'owner';
  static const String search = 'search';
  static const String leaseDetails = 'lease';
  static const String settings = 'settings';
}

// Property types
class PropertyTypes {
  static const String apartment = 'Apartment';
  static const String house = 'House';
  static const String villa = 'Villa';
  static const String condo = 'Condominium';
  static const String townhouse = 'Townhouse';
  static const String studio = 'Studio';
  static const String office = 'Office';
  static const String retail = 'Retail Space';
  static const String warehouse = 'Warehouse';
  
  static List<String> getAllTypes() {
    return [
      apartment, house, villa, condo, townhouse, studio, office, retail, warehouse
    ];
  }
}

