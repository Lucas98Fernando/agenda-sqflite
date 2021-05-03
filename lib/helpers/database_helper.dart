import 'dart:async';
import 'dart:io';
import 'package:sqflite_app/models/contato.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Definindo a classe do database, aplicando o padrão Singleton
class DatabaseHelper {
  // Instância estática e privada, só pode ser acessada dentro da classe
  static DatabaseHelper _databaseHelper;

  // Instância estática e privada do banco de dados
  static Database _database;

  // Colunas da tabela do banco de dados
  String contatoTable = 'contato';
  String colId = 'id';
  String colNome = 'nome';
  String colEmail = 'email';
  String colImage = 'imagem';

  // Contrutor nomeado para criar a instância da classe DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // Forma de garantir que só haverá uma instância da classe DatabaseHelper
    if (_databaseHelper == null) {
      // Executado apenas uma vez
      _databaseHelper = DatabaseHelper._createInstance();
    }
    // Retorna a instância já existente
    return _databaseHelper;
  }

  // Método para retornar o banco de dados, usando o Future para operações assícronaas
  Future<Database> get database async {
    if (_database == null) {
      // Inicializando o banco de dados
      _database = await initializeDatabase();
    }
    return _database;
  }

  // Método para iniciar o banco de dados
  Future<Database> initializeDatabase() async {
    // Caminho da pasta que será criado/salvo o banco de dados, serve tanto para o Android, como IOS
    Directory directory = await getApplicationDocumentsDirectory();
    // Caminho completo
    String path = directory.path + 'contatosDB.db';

    // Método para abrir o banco de dados, passando o caminho, a versão e o método de criação
    // Obs: A versão é opcional
    var contatoDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatoDatabase;
  }

  // Método assícrono privado para criação do banco de dados
  void _createDb(Database db, int newVersion) async {
    // Comando SQL
    await db.execute('CREATE TABLE $contatoTable($colId INTEGER PRIMARY KEY, '
        '$colNome TEXT, '
        '$colEmail TEXT, $colImage TEXT)');
  }

  // Métodos CRUD
  // Existem duas opções: RawSQL e Helpers SQL

  // Incluir um objeto contato no banco de dados
  Future<int> insertContato(Contato contato) async {
    // Obtendo uma instância do banco de dados
    Database db = await this.database;
    // Utilizando função SQL, convertendo o objeto para Map
    var resultado = await db.insert(contatoTable, contato.toMap());
    // Retornando o id do contato
    return resultado;
  }

  // Retornando um contato pelo id
  Future<Contato> getContato(int id) async {
    Database db = await this.database;

    // Lista do objeto contato
    List<Map> maps = await db.query(contatoTable,
        columns: [colId, colNome, colEmail, colImage],
        where: '$colId = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      // Retornando o primeiro contato da lista
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Método para exibir todos os contato em uma lista
  Future<List<Contato>> getContatos() async {
    Database db = await this.database;

    var resultado = await db.query(contatoTable);

    List<Contato> lista = resultado.isNotEmpty
        ? resultado.map((c) => Contato.fromMap(c)).toList()
        : [];
    return lista;
  }

  // Atualizar o objeto Contato e salva no banco de dados
  Future<int> updateContato(Contato contato) async {
    // Instância do banco de dados
    var db = await this.database;

    var resultado = await db.update(contatoTable, contato.toMap(),
        where: '$colId = ?', whereArgs: [contato.id]);
    return resultado;
  }

  // Deletar um objeto Contato do banco de dados
  Future<int> deleteContato(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(contatoTable, where: '$colId = ?', whereArgs: [id]);
    return resultado;
  }

  // Obtendo o número de registros de objetos Contato no banco de dados
  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $contatoTable');

    // Primeiro objeto do Map
    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  // Método para fechar o banco de dados
  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
