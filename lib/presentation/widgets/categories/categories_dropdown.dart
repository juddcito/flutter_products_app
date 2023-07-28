import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/categories/categories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/category.dart';

class CategoriesDropdown extends ConsumerStatefulWidget {
  final List<Categoryy> categories;
  final String categoryId;

  const CategoriesDropdown(
      {super.key, required this.categories, this.categoryId = '0'});

  @override
  CategoriesDropdownState createState() => CategoriesDropdownState();
}

class CategoriesDropdownState extends ConsumerState<CategoriesDropdown> {

  Categoryy? selectedCategory;
  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setCategorias();
  }

  Future<void> setCategorias() async {

    
    int selectedIndex = widget.categories.indexWhere(
        (categoria) => categoria.id.toString() == widget.categoryId);

    if (selectedIndex != -1) {
      selectedCategory = widget.categories[selectedIndex];
    }

    if (_isMounted && selectedCategory != null ) {
      return Future.delayed(const Duration(milliseconds: 300), () {
        ref.read(selectedCategoriaProvider.notifier).state =
            selectedCategory!.nombre;
        ref.read(selectedIdCategoriaProvider.notifier).state =
            selectedCategory!.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    final textStyle = Theme.of(context).textTheme.labelLarge;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4)),
      alignment: Alignment.center,
      height: 70,
      child: InputDecorator(
        decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Categoría',
            contentPadding: EdgeInsets.symmetric(horizontal: 8)),
        child: DropdownButton<Categoryy>(
          isDense: true,
          isExpanded: true,
          onChanged: (Categoryy? newValue) async {
            ref.read(selectedCategoriaProvider.notifier).state =
                newValue!.nombre;
            ref.read(selectedIdCategoriaProvider.notifier).state = newValue.id;
            setState(() {
              selectedCategory = newValue;
            });
          },
          value: selectedCategory,
          hint: const Text('Seleccione una categoría'),
          items: widget.categories
              .map<DropdownMenuItem<Categoryy>>((Categoryy category) {
            return DropdownMenuItem<Categoryy>(
                value: category,
                child: Text(category.nombre, style: textStyle));
          }).toList(),
        ),
      ),
    );
  }
}
