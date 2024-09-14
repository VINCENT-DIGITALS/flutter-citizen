class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNum;
  final String photoURL;
  final String address;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phoneNum,
    required this.photoURL,
    required this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      phoneNum: data['phoneNum'],
      photoURL: data['photoURL'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNum': phoneNum,
      'photoURL': photoURL,
      'address': address,
    };
  }
}
