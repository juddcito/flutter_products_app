

import 'package:flutter_products_app/domain/entities/marca.dart';

abstract class MarcasRepository {

  Future<List<Marca>> getMarcas();

}