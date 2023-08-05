import 'dart:async';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

typedef SearchProductCallback = Future<List<Product>> Function(String query);

class SearchProductDelegate extends SearchDelegate<Product?> {
  final SearchProductCallback searchProducts;
  StreamController<List<Product>> debounceProducts =
      StreamController.broadcast();
  Timer? _debounceTimer;
  List<Product> initialProducts;

  SearchProductDelegate(
      {required this.searchProducts, required this.initialProducts});

  void clearStreams() {
    debounceProducts.close();
  }

  void _onQueryChanged(String query) {
    print('Query string cambió');
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      final products = await searchProducts(query);
      initialProducts = products;
      debounceProducts.add(products);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(
          child: IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear)),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Lo que necesito para salir de esta búsqueda
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialProducts,
      stream: debounceProducts.stream,
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];
        return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _ProductItem(
                product: products[index],
                onProductSelected: (context, product) {
                  close(context, product);
                }));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
    
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final Function onProductSelected;

  const _ProductItem({required this.product, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    late ImageProvider imageProvider;

    if (product.imagenUrl.isEmpty){
      imageProvider = const AssetImage('assets/loaders/no_image.png');
    } else {
      Uint8List imageBytes = Uint8List.fromList(product.imagenUrl);
      imageProvider = MemoryImage(imageBytes);
    }

    return GestureDetector(
      onTap: () {
        onProductSelected(context, product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            // Necesito un tamaño específico porque estoy dentro de un row
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,)
              ),
            ),

            SizedBox(width: 10),

            // Nombre de producto
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nombre, style: textStyles.titleSmall),
                  Text(product.marca)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
