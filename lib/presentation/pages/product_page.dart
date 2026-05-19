import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product_state.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  
  @override
  void initState() {
    super.initState();
    // Carrega os produtos automaticamente ao abrir a tela
    widget.viewModel.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(state.error!),
            );
          }

          if (state.products.isEmpty) {
            return const Center(
              child: Text("Nenhum produto encontrado."),
            );
          }

          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];

              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                title: Text(product.title),
                subtitle: Text("\$${product.price}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(
                        product: product,
                      ),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        product.favorite 
                            ? Icons.star 
                            : Icons.star_border,
                        color: product.favorite ? Colors.amber : null, // Opcional: deixa a estrela amarela quando favorita
                      ),
                      onPressed: () {
                        widget.viewModel.toggleFavorite(product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductFormPage(
                              product: product,
                              viewModel: widget.viewModel,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await widget.viewModel.deleteProduct(
                          product.id,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormPage(
                viewModel: widget.viewModel,
              ),
            ),
          );

          if (result == true) {
            widget.viewModel.loadProducts();
          }
        },
      ),
    );
  }
}