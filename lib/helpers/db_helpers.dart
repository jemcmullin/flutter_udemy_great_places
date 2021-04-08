import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<void> insert(
      String tableName, Map<String, dynamic> insertData) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDb = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY_KEY, name TEXT, image TEXT)');
      },
      version: 1,
    );
    await sqlDb.insert(
      tableName,
      insertData,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}
