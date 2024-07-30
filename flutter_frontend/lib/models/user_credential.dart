class UserCredential {
  final int uid;
  final String username;
  final String email;
  final String profileImg;

  UserCredential(
      {required this.uid,
      required this.email,
      required this.username,
      required this.profileImg});

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    print("Json");
    print(json);
    return UserCredential(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      profileImg: json['profileImg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profileImg': profileImg,
    };
  }
}
