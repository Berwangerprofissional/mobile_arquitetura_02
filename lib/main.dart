import 'package:flutter/material.dart';

// Importações da Autenticação
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/pages/login_page.dart';

// Importações de Produtos
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_cache_datasource.dart'; // Import do seu Datasource de Cache
import 'data/repositories/product_repository_impl.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializa as dependências de Autenticação (DummyJSON)
  final authDatasource = AuthRemoteDatasource();
  final authRepository = AuthRepositoryImpl(authDatasource);
  final authViewModel = AuthViewModel(authRepository);

  // 2. Inicializa as dependências de Produtos com Estratégia de Cache
  final productRemoteDatasource = ProductRemoteDatasource();
  final productCacheDatasource = ProductCacheDatasource(); // Instanciando o cache requisitado
  
  // CORRIGIDO: Passando os 2 argumentos posicionais (remote e cache) exigidos pelo seu construtor
  final productRepository = ProductRepositoryImpl(
    productRemoteDatasource, 
    productCacheDatasource,
  ); 
  
  final productViewModel = ProductViewModel(productRepository);

  runApp(
    MyApp(
      authViewModel: authViewModel,
      productViewModel: productViewModel,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final ProductViewModel productViewModel;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.productViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DummyJSON App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // O app inicia obrigatoriamente na tela de login protegida
      home: LoginPage(
        authViewModel: authViewModel,
        productViewModel: productViewModel,
      ),
    );
  }
}
