class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;

  const FirebaseUser(
      {required this.email, required this.name, required this.profilePic});

  FirebaseUser copyWith({String? email, String? name, String? profilePic}) {
    return FirebaseUser(
        email: email ?? this.email,
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic);
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'profilePic': profilePic};
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}
