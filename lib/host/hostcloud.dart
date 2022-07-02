class Party {
  String? uid;
  String? party_name;
  String? image;
  String? location;
  String? discription;
  String? date;
  String? time;
  int? price;

  Party({
    this.uid,
    this.party_name,
    this.image,
    this.location,
    this.discription,
    this.date,
    this.time,
    this.price,
  });

  factory Party.fromMap(map) {
    return Party(
        uid: map['uid'],
        party_name: map['party_name'],
        image: map['image'],
        location: map['location'],
        discription: map['discription'],
        date: map['date'],
        time: map['time'],
        price: map['price']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'party_name': party_name,
      'image': image,
      'location': location,
      'discription': discription,
      'date': date,
      'time': time,
      'index': price,
    };
  }
}
