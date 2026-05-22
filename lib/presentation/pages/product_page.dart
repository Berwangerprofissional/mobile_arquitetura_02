import 'package:flutter/material.dart';
import '../../core/session/session_manager.dart'; 
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product_state.dart';
import '../viewmodels/auth_viewmodel.dart'; 
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'login_page.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProducts();
  }

  void _logout() {
    _sessionManager.clearSession();

    final authDatasource = AuthRemoteDatasource();
    final authRepository = AuthRepositoryImpl(authDatasource);
    final authViewModel = AuthViewModel(authRepository);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(
            authViewModel: authViewModel,
            productViewModel: widget.viewModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _sessionManager.currentUser?.fullName ?? "Usuário";

    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, $userName"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da conta',
            onPressed: _logout,
          ),
        ],
      ),
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
                        product.favorite ? Icons.star : Icons.star_border,
                        color: product.favorite ? Colors.amber : null,
                      ),
                      onPressed: () {
                        widget.viewModel.toggleFavorite(product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // CORRIGIDO: Adicionado 'async' e 'await' para escutar o retorno do formulário de edição
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductFormPage(
                              product: product,
                              viewModel: widget.viewModel,
                            ),
                          ),
                        );
                        
                        // Recarrega os itens atualizados na tela caso tenha salvado com sucesso
                        if (result == true) {
                          widget.viewModel.loadProducts();
                        }
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
