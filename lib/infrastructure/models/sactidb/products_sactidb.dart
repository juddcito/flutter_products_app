class ProductSactiDb {
  final int id;
  final String nombre;
  final double precio;
  final int marcaId;
  final String marca;
  final int categoriaId;
  final String categoria;

  ProductSactiDb({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.marcaId,
    required this.marca,
    required this.categoriaId,
    required this.categoria,
  });

  factory ProductSactiDb.fromJson(Map<String, dynamic> json) => ProductSactiDb(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"],
        marcaId: json["marcaId"],
        marca: json["marca"],
        categoriaId: json["categoriaId"],
        categoria: json["categoria"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "marcaId": marcaId,
        "marca": marca,
        "categoriaId": categoriaId,
        "categoria": categoria,
      };
}
