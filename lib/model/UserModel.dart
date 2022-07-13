class UserModel {
  String? uid;
  String? email;
  String? addhar;
  String? mobileno;
  String? firstName;
  String? secondName;
  List<dynamic>? party_name;

  UserModel(
      {this.uid,
      this.email,
      this.addhar,
      this.firstName,
      this.secondName,
      this.mobileno,
      this.party_name});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        addhar: map['addhar'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        mobileno: map['mobileno'],
        party_name: map['party_name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'addhar': addhar,
      'firstName': firstName,
      'secondName': secondName,
      'mobileno': mobileno,
      'party_name': party_name
    };
  }
}
