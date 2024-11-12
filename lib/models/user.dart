// lib/models/user.dart

class User {
  final String username;
  final String email;
  final String password;
  final String? profileImageUrl; // Make this optional

  User({
    required this.username,
    required this.email,
    required this.password,
    this.profileImageUrl,
  });
}
