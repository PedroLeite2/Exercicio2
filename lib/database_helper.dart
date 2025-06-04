import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "avaliacaoex2sql.db";
  static final _databaseVersion = 1;

  static final tableUsers = 'Users';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnPassword = 'password';

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
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPassword TEXT NOT NULL
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
}
