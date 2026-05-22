import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final String _baseUrl = "https://dummyjson.com/products";

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List data = decodedData['products'] as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar produtos no servidor (${response.statusCode})");
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/products/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      // Simplifica o corpo enviado para a DummyJSON não rejeitar a requisição
      body: jsonEncode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'thumbnail': product.image,
      }),
    );
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Falha simulada ao adicionar produto. Código: ${response.statusCode}");
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final response = await http.put(
      Uri.parse('https://dummyjson.com{product.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'thumbnail': product.image,
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception("Falha simulada ao atualizar produto. Código: ${response.statusCode}");
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('https://dummyjson.comid'),
    );
    
    if (response.statusCode != 200) {
      throw Exception("Falha simulada ao deletar produto. Código: ${response.statusCode}");
    }
  }
}
