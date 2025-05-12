class UserModel {
  final String id;
  final String userName;
  final String email;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
