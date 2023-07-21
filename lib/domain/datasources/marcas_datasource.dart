

import 'package:flutter_products_app/domain/entities/marca.dart';

abstract class MarcasDatasource {

  Future<List<Marca>> getMarcas();

}