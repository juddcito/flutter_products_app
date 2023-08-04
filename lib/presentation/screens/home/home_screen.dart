import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/presentation/delegates/search_product_delegate.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/search/search_products_provider.dart';
import 'package:flutter_products_app/presentation/screens/print/print_screen.dart';
import 'package:flutter_products_app/presentation/widgets/products/product_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {

  static const name = 'home-screen';

  // List para imprimir ejemplo de ticket
  final List<Map<String, dynamic>> data = [
    {'Producto': 'Gibshon Slash Guitar', 'Precio':5, 'Cantidad': 2},
    {'Producto': 'Open Box Guitar', 'Precio': 2, 'Cantidad': 4},
    {'Producto': 'Williams Overture Piano', 'Precio': 8, 'Cantidad': 6},
    {'Producto': 'Williams Overture Piano', 'Precio': 8, 'Cantidad': 6},
    {'Producto': 'Williams Overture Piano', 'Precio': 8, 'Cantidad': 6},
    {'Producto': 'Williams Overture Piano', 'Precio': 8, 'Cantidad': 6},
  ];

  final f = NumberFormat("\$###,###.00", "en_US");

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final colors = Theme.of(context).colorScheme;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrintScreen(data)
              ),
              );
            },
            icon: const Icon( Icons.print )
          ),
          IconButton(
            onPressed: ()  {
              final searchedProducts = ref.read( searchedProductProvider );
              final searchQuery = ref.read(searchQueryProvider);  
              showSearch<Product?>(
                query: searchQuery,
                context: context,
                delegate: SearchProductDelegate(
                  initialProducts: searchedProducts,
                  searchProducts: ref.read( searchedProductProvider.notifier ).searchProductsByQuery
                )
              ).then(( product ){
                if ( product == null ) return;
                context.push('/product/${product.id}');
              });
            },
            icon: const Icon( Icons.search ))
        ],
        foregroundColor: Colors.white,
        backgroundColor: colors.primary,
        title: const Text(
          'Productos',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _HomeView(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade50,
          onPressed: () {
            context.go('/create');
          },
          child: const Icon(Icons.add)
      ),
      //drawer: SideMenu(scaffoldKey: scaffoldKey)
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
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            childAspectRatio: 0.55
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return FadeInLeft(
            child: ProductItem(product: product),
          );
        });
  }
}
