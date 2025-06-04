import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "basedadosteste.db";
  static final _databaseVersion = 1;

  static final tableUsers = 'Users';
  static final columnName = 'name';
  static final columnPassword = 'password';
  static final columnScore = 'score';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnName TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL,
        $columnScore INTEGER DEFAULT 0
      )      
    ''');
  }

  Future<int> registerUser(String name, String password) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, {
      columnName: name,
      columnPassword: password,
    });
  }

  Future<bool> loginUser(String name, String password) async {
    Database db = await instance.database;
    var res = await db.query(
      tableUsers,
      where: "$columnName = ? AND $columnPassword = ?",
      whereArgs: [name, password],
    );
    return res.isNotEmpty;
  }

  Future<int?> getUserScore(String name) async {
    Database db = await instance.database;
    var res = await db.query(
      tableUsers,
      columns: [columnScore],
      where: "$columnName = ?",
      whereArgs: [name],
      limit: 1,
    );
    if (res.isNotEmpty) {
      return res.first[columnScore] as int;
    }
    return null; // or return 0 if you prefer a default
  }

  Future<int> updateUserScore(String name, int score) async {
    Database db = await instance.database;
    return await db.update(
      tableUsers,
      {columnScore: score},
      where: "$columnName = ?",
      whereArgs: [name],
    );
  }
}
