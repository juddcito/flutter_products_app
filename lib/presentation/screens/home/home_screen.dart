import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/widgets/products/product_gridview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        onPressed: () {
          context.go('/create');
        },
        child: const Icon( Icons.add )
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

    if (products.isEmpty) return const Center(child: CircularProgressIndicator());

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10
      ),
      itemCount: products.length-5,
      itemBuilder:(context, index) {
        final product = products[index];
        return ProductItem(product: product);
      });
  }
}



