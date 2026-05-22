class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  bool favorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] as int,
      title: json["title"] as String? ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0, 
      image: json["thumbnail"] as String? ?? "", 
      description: json["description"] as String? ?? "",
      favorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'thumbnail': image,
    };
  }
}
