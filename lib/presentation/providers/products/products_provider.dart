import 'package:flutter_products_app/domain/repositories/products_repository.dart';
import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  final fetchMoreProducts = ref.watch(productRepositoryProvider).getProducts;
  final deleteProductById = ref.watch(productRepositoryProvider).deleteProductById;
  final productsRepository = ref.watch ( productRepositoryProvider );

  return ProductsNotifier(fetchMoreProducts: fetchMoreProducts, deleteProduct: deleteProductById, productsRepository);
});

typedef ProductCallback = Future<List<Product>> Function({int pageIndex});
typedef DeleteProductCallback = Future<bool>Function( String productId );

class ProductsNotifier extends StateNotifier<List<Product>> {
  // Saber cuál es la página actual
  int currentPage = 0;
  ProductCallback fetchMoreProducts;
  final DeleteProductCallback deleteProduct;
  final ProductsRepository productosRepository;

  ProductsNotifier(this.productosRepository, 
      {required this.fetchMoreProducts, required this.deleteProduct})
      : super([]);

  Future<void> loadNextPage() async {
    currentPage++;

    final List<Product> products =
        await fetchMoreProducts(pageIndex: currentPage);
    state = [...state, ...products];
  }

  Future<bool> deleteProductById(String productId) async {

    final isDeleted = await deleteProduct(productId);

    if ( isDeleted ) {
      state.removeWhere((product) => product.id.toString() == productId);
      state = [...state];
      return true;
    } else {
      return false;
    }
  }
}
