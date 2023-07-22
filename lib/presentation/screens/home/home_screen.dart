import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/widgets/products/product_item.dart';
import 'package:flutter_products_app/presentation/widgets/shared/side_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: colors.primary,
        title: const Text(
          'Productos SACTI',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _HomeView(),
      ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            context.go('/create');
          },
          child: const Icon(Icons.add)
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey)
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

    ref.read(productsProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final products = ref.watch(productsProvider);

    if (products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ProductsSlideshow(
      products: products,
      loadMoreProducts: () => ref.read(productsProvider.notifier).loadNextPage()
    );
  }
}

class ProductsSlideshow extends StatefulWidget {
  final VoidCallback? loadMoreProducts;

  const ProductsSlideshow(
      {super.key, required this.products, required this.loadMoreProducts});

  final List<Product> products;

  @override
  State<ProductsSlideshow> createState() => _ProductsSlideshowState();
}

class _ProductsSlideshowState extends State<ProductsSlideshow> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadMoreProducts == null) return;

      if (scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent) {
        widget.loadMoreProducts!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 10),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return FadeInLeft(
            child: ProductItem(product: product),
          );
        });
  }
}
