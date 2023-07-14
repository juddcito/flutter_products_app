


import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {

  final fetchMoreProducts = ref.watch( productRepositoryProvider ).getProducts;

  return ProductsNotifier(
    fetchMoreProducts: fetchMoreProducts
  );
});

typedef ProductCallback = Future<List<Product>> Function({ int pageIndex });

class ProductsNotifier extends StateNotifier<List<Product>> {

  // Saber cuál es la página actual
  int currentPage = 0;
  ProductCallback fetchMoreProducts;

  ProductsNotifier({
    required this.fetchMoreProducts
  }): super([]);

  Future<void> loadNextPage() async {
    currentPage++;

    final List<Product> products = await fetchMoreProducts(pageIndex: currentPage);
    state = [...state, ...products];

  }

}