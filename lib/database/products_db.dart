import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class ProductsDB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'products.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_products(id TEXT PRIMARY KEY, title TEXT, price TEXT, imageUrl TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final sqlDB = await database();

    sqlDB.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDB = await database();
    return sqlDB.query(table);
  }
}
