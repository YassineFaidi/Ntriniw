class UserCredential {
  final int uid;
  final String username;
  final String email;

  UserCredential(
      {required this.uid, required this.email, required this.username});

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }
}
