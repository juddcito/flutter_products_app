
class ProductDetails {
    final int id;
    final String nombre;
    final double precio;
    final DateTime fechaCreacion;
    final Categoria marca;
    final Categoria categoria;

    ProductDetails({
        required this.id,
        required this.nombre,
        required this.precio,
        required this.fechaCreacion,
        required this.marca,
        required this.categoria,
    });

    factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        marca: Categoria.fromJson(json["marca"]),
        categoria: Categoria.fromJson(json["categoria"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "marca": marca.toJson(),
        "categoria": categoria.toJson(),
    };
}

class Categoria {
    final int id;
    final String nombre;

    Categoria({
        required this.id,
        required this.nombre,
    });

    factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
