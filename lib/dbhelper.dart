import 'package:sqflite/sqflite.dart';
import 'whmcslist.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "whmcs.db";
  static const _databaseVersion = 1;
  static const table = 'whmcs_table';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnUrl = "url";
  static const columnApi = "api";
  static const columnPasword = "password";
  static const columnSecret = "secret";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName VARCHAR(100) NOT NULL,
            $columnUrl VARCHAR(255) NOT NULL,
            $columnApi INTEGER(100) NOT NULL,
            $columnPasword INTEGER(100) NOT NULL,
            $columnSecret INTEGER(100) NOT NULL
          )
          ''');
  }

  // inserted row.
  Future<int> insert(Whmcslist whmcslist) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': whmcslist.name,
      'url': whmcslist.url,
      'api': whmcslist.api,
      'password': whmcslist.password,
      'secret': whmcslist.secret
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRow(id) async {
    Database db = await instance.database;
    return await db.query(table, where: "id='$id'");
  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // column values will be used to update the row.
  Future<int> update(Whmcslist whmcslist) async {
    Database db = await instance.database;
    int id = whmcslist.toMap()['id'];
    return await db.update(table, whmcslist.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  // delete
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // close connection
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
