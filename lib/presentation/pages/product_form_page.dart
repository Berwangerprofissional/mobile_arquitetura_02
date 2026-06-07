import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../../domain/entities/product.dart';

class ProductFormPage extends StatefulWidget {

  final Product? product;
  final ProductViewModel viewModel;

  const ProductFormPage({
    super.key,
    this.product,
    required this.viewModel,

  });

  @override
  State<ProductFormPage> createState() =>
      _ProductFormPageState();
}

class _ProductFormPageState
      extends State<ProductFormPage> {

  final titleController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final imageController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {

      titleController.text =
          widget.product!.title;

      priceController.text =
          widget.product!.price.toString();

      descriptionController.text =
          widget.product!.description;
      
      imageController.text =
          widget.product!.image;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.product == null
              ? 'Novo Produto'
              : 'Editar Produto',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: titleController,

              decoration:
                  const InputDecoration(
                labelText: 'Título',
              ),
            ),

            TextField(
              controller: priceController,

              decoration:
                  const InputDecoration(
                labelText: 'Preço',
              ),
            ),

            TextField(
              controller:
                  descriptionController,

              decoration:
                  const InputDecoration(
                labelText: 'Descrição',
              ),
            ),

            TextField(
              controller: 
                imageController,

              decoration: 
                  const InputDecoration(
                labelText: 'URL da imagem',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () async{

                final updatedProduct = Product(
                
                  id: widget.product?.id ?? 0,

                  title: titleController.text,

                  price: double.parse(
                    priceController.text,
                  ),

                  description:
                      descriptionController.text,

                  image: imageController.text,
                );

                if (widget.product != null) {                                
                  await widget.viewModel
                      .updateProduct(updatedProduct);
                } else {              
                  await widget.viewModel
                      .addProduct(updatedProduct);
                }                
                Navigator.pop(context);
              },

              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}