import 'package:flutter/material.dart';

class Product {
  final String id, name, imageUrl;
  final int price;
  final IconData fallbackIcon;
  final bool isAsset;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.fallbackIcon,
    required this.imageUrl,
    this.isAsset = false,
  });

  // Konversi dari Map Database SQLite ke Object Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'] ?? 'assets/hoodie_23.jpg',
      fallbackIcon: Icons.shopping_bag_rounded,
      isAsset: map['isAsset'] == 1,
    );
  }

  // Konversi dari Object Product ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'isAsset': isAsset ? 1 : 0,
    };
  }
}