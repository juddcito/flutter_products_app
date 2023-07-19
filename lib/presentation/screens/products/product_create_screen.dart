import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCreateScreen extends ConsumerStatefulWidget {


  static const name = 'product_create_screen';
  const ProductCreateScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
  
}

class ProductScreenState extends ConsumerState<ProductCreateScreen> {

  @override
  void initState() {
    super.initState();

    // Hacer la petición GET del producto


  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Agregar producto',
            style: TextStyle(color: Colors.white)),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      body: _ProductCreateView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon( Icons.save_as_sharp ),
      ),
    );
  
  }

}

class _ProductCreateView extends StatelessWidget {
  const _ProductCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
