import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}
class _SideMenuState extends State<SideMenu> {


  int navDrawerIndex = 0;

  

  @override
  Widget build(BuildContext context) {

    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyle = Theme.of(context).textTheme.titleLarge;

    return NavigationDrawer(
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });
          context.push('/create');
        },
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(20, hasNotch ? 30 : 50 , 16, 10),
            child: Text('Menú principal', style: textStyle),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text('Agregar un producto'))
        ]);
  }
}
