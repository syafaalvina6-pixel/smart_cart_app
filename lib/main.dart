import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/product_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Catalog Fashion Store',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF9F8FE),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B63DA),
            primary: const Color(0xFF8B63DA),
          ),
          fontFamily: 'Roboto',
        ),
        home: const CatalogPage(),
      ),
    );
  }
}