// UI-only user model for displaying user information

enum UserRole { owner, customer }

class UserPreferences {
  final bool darkModeEnabled;
  final String preferredLanguage;
  final String preferredCurrency;
  final bool notificationsEnabled;

  UserPreferences({
    this.darkModeEnabled = false,
    this.preferredLanguage = 'English',
    this.preferredCurrency = 'USD',
    this.notificationsEnabled = true,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserRole role;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String>? propertyIds;
  final List<String>? favoritePropertyIds;
  final List<String>? leasedPropertyIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.role,
    required this.preferences,
    required this.createdAt,
    required this.lastLoginAt,
    this.propertyIds,
    this.favoritePropertyIds,
    this.leasedPropertyIds,
  });

  // Create a sample user for UI display
  static User getSampleUser({UserRole role = UserRole.customer}) {
    return User(
      id: '1',
      name: role == UserRole.owner ? 'John Owner' : 'Alice Renter',
      email: role == UserRole.owner ? 'john@example.com' : 'alice@example.com',
      phoneNumber: '555-123-4567',
      profileImageUrl: 'assets/images/profile.jpg',
      role: role,
      preferences: UserPreferences(
        darkModeEnabled: false,
        preferredLanguage: 'English',
        preferredCurrency: 'USD',
        notificationsEnabled: true,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
      propertyIds: role == UserRole.owner ? ['1', '2', '3'] : null,
      favoritePropertyIds: role == UserRole.customer ? ['1', '4'] : null,
      leasedPropertyIds: role == UserRole.customer ? ['2'] : null,
    );
  }
}
