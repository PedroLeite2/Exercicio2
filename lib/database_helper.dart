import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Guarda localmente o nome do utilizador autenticado
  Future<void> saveLoggedUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedUser', username);
  }

  // Obtém o utilizador logado (ou null se não houver)
  Future<String?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedUser');
  }

  // Remove o utilizador autenticado (logout)
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
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
    int? scoreAtual = await getUserScore(name);

    if (scoreAtual != null) {
      scoreAtual += score;
    }

    return await db.update(
      tableUsers,
      {columnScore: scoreAtual},
      where: "$columnName = ?",
      whereArgs: [name],
    );
  }

  Future<List<Map<String, dynamic>>> getTop5Scores() async {
    final db = await instance.database;
    return await db.query(
      tableUsers,
      columns: [columnName, columnScore],
      orderBy: "$columnScore DESC",
      limit: 5,
    );
  }
}
