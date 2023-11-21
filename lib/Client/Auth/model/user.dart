class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobileNumber;
  final String vehicleNumber;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.vehicleNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      mobileNumber: json['mobileNumber'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'mobileNumber': mobileNumber,
      'vehicleNumber': vehicleNumber,
    };
  }
}
