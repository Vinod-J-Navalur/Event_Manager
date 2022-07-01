class UserModel {
  String? uid;
  String? email;
  String? addhar;
  String? mobileno;
  String? firstName;
  String? secondName;

  UserModel(
      {this.uid,
      this.email,
      this.addhar,
      this.firstName,
      this.secondName,
      this.mobileno});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        addhar: map['addhar'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        mobileno: map['mobileno']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'addhar': addhar,
      'firstName': firstName,
      'secondName': secondName,
      'mobileno': mobileno
    };
  }
}
