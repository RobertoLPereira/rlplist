import 'dart:async';

import 'AbstractModel.dart';
import 'package:thizerlist/application.dart';
import 'package:sqflite/sqflite.dart';

class ModelFornec extends AbstractModel {
  ///
  /// Singleton
  ///

  static ModelFornec _this;

  factory ModelFornec() {
    if (_this == null) {
      _this = ModelFornec.getInstance();
    }
    return _this;
  }

  ModelFornec.getInstance() : super();

  ///
  /// The Instance
  ///

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    var sql = '''
      SELECT
        L.*,F.name as contato,F.nomeFornec,F.tel,
        (
          SELECT COUNT(1)
          FROM item as i
          WHERE i.fk_lista = L.pk_lista
        ) as qtdItems
      FROM lista as L
      left join fornec f on f.pk_fornec = L.fk_fornec
      ORDER BY  created DESC
    ''';
    // ignore: unused_local_variable
    var sqlF = '''
      SELECT
        F.*,
        (
          SELECT COUNT(1)
          FROM list as l
          WHERE l.fk_fornec = F.pk_fornec
        ) as qtdItems
      FROM fornec as F
      ORDER BY  created DESC
    ''';
    return db.rawQuery(sql);
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> listas = await db.query('list',
        where: 'pk_lista = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (listas.isNotEmpty) {
      result = listas.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('fornec', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {
    Database db = await this.getDb();
    int rows = await db
        .update('fornec', values, where: 'pk_fornec = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete('fornec', where: 'pk_fornec = ?', whereArgs: [id]);

    return (rows != 0);
  }
}
