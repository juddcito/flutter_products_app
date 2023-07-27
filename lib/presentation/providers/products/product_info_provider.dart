// Este provider proporciona la información de un Product individual

import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';
final productInfoProvider = StateNotifierProvider<ProductMapNotifier, Map<String,Product>>((ref) {
  final productRepository = ref.watch( productRepositoryProvider );
  return ProductMapNotifier(getProduct: productRepository.getProductById);
});


typedef GetProductCallback = Future<Product>Function( String productId );

class ProductMapNotifier extends StateNotifier<Map<String,Product>>{

  final GetProductCallback getProduct;

  ProductMapNotifier({
    required this.getProduct,
  }): super({});

  Future<void> loadProduct( String productId ) async {
    
    //if( state[productId] != null ) return;

    final product = await getProduct( productId );

    state = { ...state, productId: product };

  }

}