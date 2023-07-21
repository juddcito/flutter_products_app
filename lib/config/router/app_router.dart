import 'package:flutter_products_app/presentation/screens/home/home_screen.dart';
import 'package:flutter_products_app/presentation/screens/products/product_create_screen.dart';
import 'package:flutter_products_app/presentation/screens/products/product_details_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
    routes: [
      GoRoute(
        path: 'product/:id',
        name: ProductDetailsScreen.name,
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '1';
          return ProductDetailsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: 'create',
        name: ProductCreateScreen.name,
        builder:(context, state) => const ProductCreateScreen(),
      )
    ],
  ),
]);
