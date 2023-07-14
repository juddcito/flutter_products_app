import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/products/products_providers.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon( Icons.production_quantity_limits_rounded ),
        title: const Text ('Productos SACTI'),
      ),
      body: _HomeView()
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView({super.key});

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

    return ListView.builder(
      itemCount: products.length,
      itemBuilder:(context, index) {
        final product = products[index];

        return ListTile(
          title: Text( product.nombre ),
        );
      });
  }
}