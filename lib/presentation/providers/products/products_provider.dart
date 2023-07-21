
import 'dart:ffi';

import 'package:flutter_products_app/domain/repositories/products_repository.dart';
import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  final fetchMoreProducts = ref.watch(productRepositoryProvider).getProducts;
  final deleteProductById = ref.watch(productRepositoryProvider).deleteProductById;
  final updateProduct = ref.watch(productRepositoryProvider).updateProduct;
  final productsRepository = ref.watch( productRepositoryProvider );
  final postProduct = ref.watch(productRepositoryProvider).postProduct;

  return ProductsNotifier(
    fetchMoreProducts: fetchMoreProducts,
    deleteProduct: deleteProductById,
    productsRepository,
    updateProduct: updateProduct,
    postProduct: postProduct
  );
});

typedef ProductCallback = Future<List<Product>> Function({int pageIndex});
typedef DeleteProductCallback = Future<bool>Function( String productId );
typedef UpdateProductCallback = Future<void>Function( Product product );
typedef PostProductCallback = Future<void>Function( Map<String,dynamic> product );

class ProductsNotifier extends StateNotifier<List<Product>> {
  // Saber cuál es la página actual
  int currentPage = 0;
  ProductCallback fetchMoreProducts;
  final DeleteProductCallback deleteProduct;
  final ProductsRepository productosRepository;
  final UpdateProductCallback updateProduct;
  final PostProductCallback postProduct;

  ProductsNotifier(this.productosRepository, 
      {required this.fetchMoreProducts, required this.deleteProduct, required this.updateProduct, required this.postProduct})
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

  Future<void> updateProductByProduct( Product product ) async {

    await updateProduct(product);
    state = [...state];

  }

  Future<void> postProductByProduct( Map<String,dynamic> product ) async {

    await postProduct(product);
    state = [...state];

  }

}

final productNameProvider = StateProvider<String>((ref) => '');
final productPriceProvider = StateProvider<double>((ref) => 0);
