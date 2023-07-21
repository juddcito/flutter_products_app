

import 'package:flutter_products_app/presentation/providers/categories/categories_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/category.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Categoryy>>((ref) {
  final fetchCategories = ref.watch( categoriesRepositoryProvider ).getCategories;

  return CategoriesNotifier(fetchCategories: fetchCategories);

});

typedef CategoryCallback = Future<List<Categoryy>> Function();


class CategoriesNotifier extends StateNotifier<List<Categoryy>> {

  final CategoryCallback fetchCategories;

  CategoriesNotifier({required this.fetchCategories}):super([]);

  Future<void> loadCategories() async {

    if(state.isNotEmpty){
      return;
    }
    
    final List<Categoryy> categories = await fetchCategories();
    state = [...state, ...categories];

  }
}

final selectedIdCategoriaProvider = StateProvider<int>((ref) => 0);
final selectedCategoriaProvider = StateProvider<String>((ref) => '');