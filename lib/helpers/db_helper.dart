import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import '../models/product.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'fashion_store.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, price INTEGER, imageUrl TEXT, isAsset INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertProduct(Product product) async {
    final db = await DBHelper.database();
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Product>> getProducts() async {
    final db = await DBHelper.database();
    final data = await db.query('products');
    return data.map((item) => Product.fromMap(item)).toList();
  }
}