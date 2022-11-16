
class PersonModel {
  static List<Person> person = [];
}

class Person {
  final int id;
  final String name;
  final String price;
  final String time;
  final String image;

  Person(
      {required this.id,
        required this.name,
        required this.price,
        required this.image,
        required this.time});

  // ignore: non_constant_identifier_names
  factory Person.FromMap(Map<String, dynamic> map) {
    return Person(
      id: map["id"],
      name: map["name"],
      price: map["price"],
      time: map["time"],
      image: map["image"],
    );
  }
  toMap() => {"id": id, "name": name, "price": price, "image": image};
}