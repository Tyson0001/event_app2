class User {
  final String username;
  final String email;
  final String password;
  final String? profession;  // Add profession as an optional field

  // Constructor
  User({
    required this.username,
    required this.email,
    required this.password,
    this.profession,  // Allow it to be nullable or passable
  });

// Optional: You can add a getter or method if you need to process the profession in a special way
}
