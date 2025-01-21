class PetModel {
  final int id;
  final String name;
  final int age;
  final int price;
  final String image;
  bool adopted;

  PetModel({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.image,
    this.adopted = false,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      price: json['price'],
      image: json['image'],
      adopted: json['adopted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'price': price,
      'image': image,
      'adopted': adopted,
    };
  }
}

final List<PetModel> mockPetData = [
  for (int i = 1; i <= 30; i++)
    PetModel(
      id: i,
      name: 'Pet$i',
      age: i % 5 + 1,
      price: 100 + i * 10,
      image: 'https://images.dog.ceo/breeds/poodle-toy/n02113624_429.jpg',
    ),
];