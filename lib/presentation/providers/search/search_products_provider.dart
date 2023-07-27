

import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

final searchQueryProvider = StateProvider((ref) => '');

final searchedProductProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Product>>((ref) {
  final productRepository = ref.read( productRepositoryProvider );

  return SearchedMoviesNotifier(
    searchProducts: productRepository.searchProducts, 
    ref: ref
  );

});

typedef SearchMoviesCallback = Future<List<Product>> Function( String query );

class SearchedMoviesNotifier extends StateNotifier<List<Product>> {

  final SearchMoviesCallback searchProducts;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchProducts,
    required this.ref
  }): super([]);

  Future<List<Product>> searchProductsByQuery( String query ) async {

    final List<Product> products = await searchProducts( query );
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = products;
    return products;

  }

}