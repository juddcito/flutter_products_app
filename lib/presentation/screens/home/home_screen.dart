import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/widgets/products/product_listview.dart';
import 'package:flutter_products_app/presentation/widgets/shared/custom_appbar.dart';
import 'package:flutter_products_app/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';
import '../../providers/products/products_providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
        body: _HomeView(),
        bottomNavigationBar: CustomBottomNavigation(),
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

    // ref.read( productsProvider.notifier ).loadNextPage();
  }

  List<Product> myProducts = [
    Product(1, 'Guitarra eléctrica', 6000.00, 1, 'Fender', 2,
        'Instrumentos musicales', 'https://ss631.liverpool.com.mx/xl/1090904431.jpg'),
    Product(2, 'Guitarra acústica', 1249.00, 2, 'Ocelotl', 2,
        'Instrumentos musicales', 'https://cdn1.coppel.com/images/catalog/mkp/749/3000/7491226-1.jpg'),
    Product(3, 'Guitarra eléctrica', 5000.00, 1, 'Fender', 2,
        'Instrumentos musicales', 'https://www.mrcdinstrumentos.com.mx/shared/productos/1819/0111602800.jpg'),
    Product(4, 'Guitarra eléctrica', 2016.72, 3, 'Lyxpro', 2,
        'Instrumentos musicales', 'https://m.media-amazon.com/images/I/61fLcVETzUL.jpg'),
    Product(5, 'Guitarra eléctrica', 6000, 4, 'Smithfire', 2,
        'Instrumentos musicales', 'https://www.falymusic.com/images/detailed/47/ISSMISMI111PAK.jpg'),
    Product(6, 'Guitarra eléctrica', 7483.13, 5, 'Yamaha', 2,
        'Instrumentos musicales', 'https://m.media-amazon.com/images/I/71cTeubzQOL.jpg'),
    Product(7, 'Guitarra eléctrica', 3271.65, 6, 'Deviser', 2,
        'Instrumentos musicales', 'https://m.media-amazon.com/images/I/61PPQAx1xaL.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    // final products = ref.watch( productsProvider );

    return CustomScrollView(
      
      slivers: [
         const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
            titlePadding: EdgeInsets.all(0),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                ProductListview(products: myProducts)
              ],
            );
          }, childCount: 1)
        )
      ],
    );
  }
}



