import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/widgets/products/product_gridview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/products/products_providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        leading: const Icon( Icons.menu_outlined, color: Colors.white,),
        title: const Text ('Productos SACTI', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _HomeView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon ( Icons.add_outlined )
      ),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {


  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read( productsProvider.notifier ).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {

    final products = ref.watch( productsProvider );

    if (products.isEmpty) return Center(child: CircularProgressIndicator());

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10
      ),
      itemCount: products.length,
      itemBuilder:(context, index) {
        final product = products[index];
        return ProductItem(product: product);
      });
  }
}



