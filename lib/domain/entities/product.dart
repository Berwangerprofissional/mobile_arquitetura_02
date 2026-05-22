class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;

  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,

    this.favorite = false,
  });
  
  Product copyWith({bool? favorite}) {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      image: image,
      favorite: favorite ?? this.favorite,
    );
  }
}