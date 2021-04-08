import 'package:sqflite/sqflite.dart' as sql;
// import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    // final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      'places.db',
      // path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY_KEY, name TEXT, image TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(
      String tableName, Map<String, Object> insertData) async {
    final db = await DBHelper.database();
    await db.insert(
      tableName,
      insertData,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
