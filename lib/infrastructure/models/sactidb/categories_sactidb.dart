
class CategorySactiDb {
    final int id;
    final String nombre;

    CategorySactiDb({
        required this.id,
        required this.nombre,
    });

    factory CategorySactiDb.fromJson(Map<String, dynamic> json) => CategorySactiDb(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
