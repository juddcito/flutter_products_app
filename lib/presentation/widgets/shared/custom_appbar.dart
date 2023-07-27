import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/delegates/search_product_delegate.dart';

class CustomAppBar extends StatelessWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon ( Icons.shop, color: colors.primary, size: 32, ),
              const SizedBox( width: 8 ),
              Text('Productos SACTI', style: titleStyle,),
              const Spacer(),
              IconButton(
                onPressed: () {


                },
                icon: const Icon ( Icons.search )
              )
            ],
          ),
        ),
      ));
  }
}