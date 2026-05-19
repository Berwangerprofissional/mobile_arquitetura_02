import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_cache_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();

      cache.save(models);

      return models.map((m) => Product(
            id: m.id,
            title: m.title,
            price: m.price,
            image: m.image,
            description: m.description,
            favorite: false,

          )).toList();

    } catch (e) {

      final cached = cache.get();

      if (cached != null) {
        return cached.map((m) => Product(
              id: m.id,
              title: m.title,
              price: m.price,
              image: m.image,
              description: m.description,
              favorite: false,
            )).toList();
      }

      throw Failure("Não foi possível carregar os produtos");
    }
  }
  
  @override
  Future<void> deleteProduct(int id) async {

    await remote.deleteProduct(id);
  }

  @override
  Future<void> updateProduct(
    Product product,
  ) async {

    final model = ProductModel(

      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      image: product.image,
      favorite: false,

    );

    await remote.updateProduct(model);
  }

  @override
  Future<void> addProduct(
    Product product,
  ) async {

    final model = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      image: product.image,
      favorite: false,

    );

    await remote.addProduct(model);
  }
}