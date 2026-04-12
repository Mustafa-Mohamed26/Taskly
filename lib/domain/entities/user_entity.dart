class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phone;
  final String? bio;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.phone,
    this.bio,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phone,
    String? bio,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
    );
  }
}
