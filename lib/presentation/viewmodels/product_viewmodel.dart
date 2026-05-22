import 'package:flutter/material.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';
import '../../domain/entities/product.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);

    try {
      final products = await repository.getProducts();

      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      // Tenta apagar do servidor DummyJSON
      await repository.deleteProduct(id);
    } catch (_) {
      // Ignora erros de rede (como 404 para IDs criados localmente que não existem no servidor real)
    }

    // Executa a remoção local obrigatoriamente para manter o app fluído
    final updatedList = state.value.products.where((product) {
      return product.id != id;
    }).toList();

    state.value = state.value.copyWith(
      products: updatedList,
    );
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      // Tenta atualizar no servidor DummyJSON
      await repository.updateProduct(updatedProduct);
    } catch (_) {
      // Ignora erros de rede para IDs criados localmente
    }

    // Executa a atualização local obrigatoriamente na lista em tela
    final updatedList = state.value.products.map((product) {
      if (product.id == updatedProduct.id) {
        return updatedProduct;
      }
      return product;
    }).toList();

    state.value = state.value.copyWith(
      products: updatedList,
    );
  }

  Future<void> addProduct(Product product) async {
    try {
      await repository.addProduct(product);
    } catch (_) {
      // Proteção de rede
    }
  
    final updatedList = [
      ...state.value.products,
      product,
    ];
  
    state.value = state.value.copyWith(
      products: updatedList,
    );
  }
  
  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;
  
    state.value = state.value.copyWith(
      products: List.from(state.value.products),
    );
  }
}
