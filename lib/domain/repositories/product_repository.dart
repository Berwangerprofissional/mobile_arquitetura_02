import '../entities/product.dart';

abstract class ProductRepository {

  Future<List<Product>> getProducts();

  Future<void> deleteProduct(int id);
  
  Future<void> updateProduct(Product product);

  Future<void> addProduct(Product product);
}