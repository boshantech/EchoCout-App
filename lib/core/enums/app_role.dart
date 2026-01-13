/// Enum representing the user role in the application
enum AppRole {
  /// Regular waste collector user
  user,

  /// Waste collection driver
  driver,
}

extension AppRoleExtension on AppRole {
  /// Get display name for the role
  String get displayName {
    switch (this) {
      case AppRole.user:
        return 'User';
      case AppRole.driver:
        return 'Driver';
    }
  }

  /// Check if this is a driver role
  bool get isDriver => this == AppRole.driver;

  /// Check if this is a user role
  bool get isUser => this == AppRole.user;
}
