import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: (){
        context.go('/product/${ product.id }');
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 54,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                product.nombre,
                style: textStyle.titleMedium,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(product.marca),
                  Text('\$' + product.precio.toString())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
