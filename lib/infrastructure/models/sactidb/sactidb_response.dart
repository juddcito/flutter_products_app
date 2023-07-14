

import 'package:flutter_products_app/infrastructure/models/sactidb/product_sactidb.dart';

class SactiDbResponse {
    final dynamic search;
    final int pageIndex;
    final int pageSize;
    final int total;
    final List<ProductSactiDb> registers;
    final int totalPages;
    final bool hasPreviusPage;
    final bool hasNextPage;

    SactiDbResponse({
        this.search,
        required this.pageIndex,
        required this.pageSize,
        required this.total,
        required this.registers,
        required this.totalPages,
        required this.hasPreviusPage,
        required this.hasNextPage,
    });

    factory SactiDbResponse.fromJson(Map<String, dynamic> json) => SactiDbResponse(
        search: json["search"],
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        total: json["total"],
        registers: List<ProductSactiDb>.from(json["registers"].map((x) => ProductSactiDb.fromJson(x))),
        totalPages: json["totalPages"],
        hasPreviusPage: json["hasPreviusPage"],
        hasNextPage: json["hasNextPage"],
    );

    Map<String, dynamic> toJson() => {
        "search": search,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "total": total,
        "registers": List<dynamic>.from(registers.map((x) => x.toJson())),
        "totalPages": totalPages,
        "hasPreviusPage": hasPreviusPage,
        "hasNextPage": hasNextPage,
    };
}

