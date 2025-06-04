import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "avaliacaoex2sqlite.db";
  static final _databaseVersion = 1;
  static final table = 'Cursos';
  static final columnId = 'id';
  static final columnName = 'nome';
  // Classe que usa padrão singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  // Abre a base de dados e o cria (se não existir)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL para criar a tabela (se não existir)
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table (
$columnId INTEGER PRIMARY KEY,
$columnName VARCHAR(50)
)
''');
  }

  // Método para inserir dados
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Método para consultar todos os dados
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
