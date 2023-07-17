import 'package:flutter/material.dart';
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
        leading: Icon( Icons.menu_outlined, color: Colors.white,),
        title: Text ('Productos SACTI', style: TextStyle(color: Colors.white),),
      ),
      body: _HomeView()
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

    // ref.read( productsProvider.notifier ).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {
    // final products = ref.watch( productsProvider );

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



