import 'package:flutter/material.dart';

import 'data/datasources/product_cache_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';

import 'presentation/pages/home_page.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() {
  final remote = ProductRemoteDatasource();
  final cache = ProductCacheDatasource();

  final repository =
      ProductRepositoryImpl(remote, cache);

  final viewModel =
      ProductViewModel(repository);

  runApp(MyApp(viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(viewModel: viewModel),
    );
  }
}