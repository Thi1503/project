class User {
  int? userId;
  String? username;
  String? email;
  String? password;
  DateTime? createdAt; // Thay đổi kiểu dữ liệu thành DateTime

  User({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.createdAt,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'password': password,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Extract a User object from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
