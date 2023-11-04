class PersonDataModel {
  int? id;
  final String name;
  final String email;
  final String password;
  final String profileImage;
  final bool hasRevolut;

  PersonDataModel({
    this.id,
    this.email = '',
    this.password = '',
    required this.name,
    this.profileImage = 'assets/profil.png',
    this.hasRevolut = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'hasRevolut': hasRevolut ? 1 : 0,
    };
  }

  factory PersonDataModel.fromMap(Map<String, dynamic> map) {
    return PersonDataModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profileImage: map['profileImage'],
      hasRevolut: map['hasRevolut'] == 1,
    );
  }
}
