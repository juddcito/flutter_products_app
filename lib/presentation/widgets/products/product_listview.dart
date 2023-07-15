import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';

class ProductListview extends StatelessWidget {
  final List<Product> products;

  const ProductListview({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeIn(child: _ProductSlide(product: products[index]));
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ProductSlide extends StatelessWidget {
  final Product product;

  const _ProductSlide({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          //* Imagen
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(product.image),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( product.nombre, style: textStyles.titleMedium, ),
                Text( product.marca, style: textStyles.bodyMedium, ),
                Text( product.precio.toString(), style: textStyles.bodyMedium, )
              ],
            ),
          ),
          const Spacer(),
          IconButton(onPressed: (){}, icon: Icon( Icons.navigate_next ))
        ],
      ),
    );
  }
}
