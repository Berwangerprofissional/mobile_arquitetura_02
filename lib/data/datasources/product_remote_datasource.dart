import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRemoteDatasource {

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );
    final List data = json.decode(response.body);

    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await http.post(
      Uri.parse('https://fakestoreapi.com/products'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(product.toJson()),
    );
  }

  Future<void> updateProduct(
  ProductModel product,
    ) async {
    
      await http.put(
      
        Uri.parse(
          'https://fakestoreapi.com/products/${product.id}',
        ),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode(
          product.toJson(),
        ),
      );
    }

  Future<void> deleteProduct(int id) async {
    await http.delete(
      Uri.parse(
        'https://fakestoreapi.com/products/$id'
        ),
    );
  }
}