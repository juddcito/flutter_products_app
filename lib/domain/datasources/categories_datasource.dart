

import '../entities/category.dart';

abstract class CategoryDatasource {

  
  Future<List<Categoryy>> getCategories();


}