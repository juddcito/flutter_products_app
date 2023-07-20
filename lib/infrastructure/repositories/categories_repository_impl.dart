

import 'package:flutter_products_app/domain/datasources/categories_datasource.dart';
import 'package:flutter_products_app/domain/entities/category.dart';
import 'package:flutter_products_app/domain/repositories/categories_repository.dart';
import 'package:flutter_products_app/infrastructure/datasources/sactidb_datasource.dart';

class CategoryRepositoryImpl extends CategoriesRepository {

  final SactiDbDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<List<Categoryy>> getCategories() {
    return datasource.getCategories();
  }


}