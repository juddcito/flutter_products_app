import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';

class ProductItem extends ConsumerStatefulWidget {
  
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    late ImageProvider imageProvider;

    if ( widget.product.imagenUrl.isNotEmpty ) {
      Uint8List imageBytes = Uint8List.fromList(widget.product.imagenUrl);
      imageProvider = MemoryImage(imageBytes);
    } else { 
      imageProvider = const AssetImage('assets/loaders/no_image.png');
    }

    return GestureDetector(
      onTap: (){
        context.go('/product/${ widget.product.id }');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.product.nombre,
              style: textStyle.titleMedium,
              maxLines: 2,
            ),
            Text(widget.product.marca),
            Text('\$${widget.product.precio}')
          ],
        ),
      ),
    );
  }
}
