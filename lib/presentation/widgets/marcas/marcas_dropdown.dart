import 'package:flutter/material.dart';
import 'package:flutter_products_app/domain/entities/marca.dart';
import 'package:flutter_products_app/presentation/providers/marcas/marcas_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarcasDropdown extends ConsumerStatefulWidget {
  final List<Marca> marcas;
  final String marcaId;

  const MarcasDropdown({super.key, required this.marcas, this.marcaId = '0'});

  @override
  _MarcasDropdownState createState() => _MarcasDropdownState();
}

class _MarcasDropdownState extends ConsumerState<MarcasDropdown> {
  Marca? selectedMarca;
  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setMarcas();
  }

  Future<void> setMarcas() async {
    if (_isMounted) {
      await Future.delayed(const Duration(milliseconds: 300), () {
        ref.read(selectedMarcaProvider.notifier).state = selectedMarca!.nombre;
        ref.read(selectedIdMarcaProvider.notifier).state = selectedMarca!.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    int selectedIndex = widget.marcas
        .indexWhere((marca) => marca.id.toString() == widget.marcaId);

    if (selectedIndex != -1) {
      selectedMarca = widget.marcas[selectedIndex];
    }

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
            labelText: 'Marca',
            contentPadding: EdgeInsets.symmetric(horizontal: 8)),
        child: DropdownButton<Marca>(
          isDense: true,
          isExpanded: true,
          onChanged: (Marca? newValue) {
            ref.read(selectedMarcaProvider.notifier).state = newValue!.nombre;
            ref.read(selectedIdMarcaProvider.notifier).state = newValue.id;
            setState(() {
              selectedMarca = newValue;
            });
          },
          value: selectedMarca,
          hint: const Text('Seleccione una marca'),
          items: widget.marcas.map<DropdownMenuItem<Marca>>((Marca marca) {
            return DropdownMenuItem<Marca>(
                value: marca, child: Text(marca.nombre, style: textStyle));
          }).toList(),
        ),
      ),
    );
  }
}
