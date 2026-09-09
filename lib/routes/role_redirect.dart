enum UserRole {
  customer,
  admin,
  superAdmin,
  delivery,
  doctor;

  static UserRole fromString(String? value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'superadmin':
      case 'super_admin':
        return UserRole.superAdmin;
      case 'delivery':
        return UserRole.delivery;
      case 'doctor':
        return UserRole.doctor;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.superAdmin:
        return 'superadmin';
      case UserRole.delivery:
        return 'delivery';
      case UserRole.doctor:
        return 'doctor';
      case UserRole.customer:
        return 'customer';
    }
  }
}

/// Central place that decides where each role lands after login.
/// Update the paths here if your router uses different route names.
class RoleRedirect {
  const RoleRedirect._();

  static String homeRouteFor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin';
      case UserRole.superAdmin:
        return '/superadmin';
      case UserRole.delivery:
        return '/delivery';
      case UserRole.doctor:
        return '/doctor';
      case UserRole.customer:
        return '/home';
    }
  }
}
