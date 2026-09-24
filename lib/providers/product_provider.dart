import 'package:flutter/material.dart';
import '../models/product.dart';
import '../helpers/db_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  // Data dummy awal LKPD
  final List<Product> _initialProducts = [
    Product(id: 'p1', name: 'Hoodie Oversize', price: 120000, fallbackIcon: Icons.dry_cleaning_rounded, imageUrl: 'assets/hoodie_23.jpg', isAsset: true),
    Product(id: 'p2', name: 'Sneakers Unisex', price: 250000, fallbackIcon: Icons.roller_skating_rounded, imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80'),
    Product(id: 'p3', name: 'Backpack Simple', price: 180000, fallbackIcon: Icons.backpack_rounded, imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80'),
    Product(id: 'p4', name: 'Topi Baseball', price: 75000, fallbackIcon: Icons.sports_baseball_rounded, imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500&q=80'),
    Product(id: 'p5', name: 'Jam Tangan', price: 150000, fallbackIcon: Icons.watch_rounded, imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80'),
    Product(id: 'p6', name: 'Kacamata Hitam', price: 100000, fallbackIcon: Icons.visibility_rounded, imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&q=80'),
  ];

  // Mengambil data dari SQLite saat aplikasi dibuka
  Future<void> fetchProducts() async {
    try {
      var dbList = await DBHelper.getProducts();
      if (dbList.isEmpty) {
        for (var p in _initialProducts) {
          await DBHelper.insertProduct(p);
        }
        dbList = await DBHelper.getProducts();
      }
      _products = dbList;
    } catch (e) {
      // Fallback jika dibuka di Web / SQLite tidak aktif
      _products = _initialProducts;
    }
    notifyListeners();
  }

  // Menambah produk baru ke daftar & SQLite
  Future<void> addProduct(String name, int price, String imageUrl) async {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      fallbackIcon: Icons.shopping_bag_rounded,
      imageUrl: imageUrl.isEmpty
          ? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80'
          : imageUrl,
      isAsset: false,
    );

    _products.add(newProduct);
    notifyListeners();

    try {
      await DBHelper.insertProduct(newProduct);
    } catch (e) {
      // Abaikan error DB jika di web
    }
  }
}