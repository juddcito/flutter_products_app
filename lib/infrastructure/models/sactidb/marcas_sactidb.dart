
class MarcaSactiDb {
    final int id;
    final String nombre;

    MarcaSactiDb({
        required this.id,
        required this.nombre,
    });

    factory MarcaSactiDb.fromJson(Map<String, dynamic> json) => MarcaSactiDb(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}