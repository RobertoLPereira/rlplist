import 'dart:async';

import 'AbstractModel.dart';
import 'package:thizerlist/application.dart';
import 'package:sqflite/sqflite.dart';

enum ListsListOrderBy { alphaASC, alphaDESC }

enum ListsListFilterBy { checked, unchecked, all }

class ModelLista extends AbstractModel {
  ///
  /// Singleton
  ///

  static ModelLista _this;

  factory ModelLista() {
    if (_this == null) {
      _this = ModelLista.getInstance();
    }
    return _this;
  }

  ModelLista.getInstance() : super();

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
    // ignore: unused_local_variable
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

  Future<List<Map>> listsByList(
    int fkFornec,
    ListsListOrderBy orderBy,
    ListsListFilterBy filterBy,
  ) async {
    Database db = await this.getDb();
    return db.rawQuery('''
      SELECT
        L.*,
        (
          SELECT COUNT(1)
          FROM item as i
          WHERE i.fk_lista = L.pk_lista
        ) as qtdItems
      FROM lista as L
      where 
       L.fk_fornec = $fkFornec
        ${filterBy == ListsListFilterBy.checked ? 'AND i.checked = 1' : ''}
        ${filterBy == ListsListFilterBy.unchecked ? 'AND i.checked = 0' : ''}
      ORDER BY LOWER(i.name) ${(orderBy == ListsListOrderBy.alphaASC) ? 'ASC' : 'DESC'}
    ''');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('lista',
        where: 'pk_lista = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('lista', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {
    Database db = await this.getDb();
    int rows = await db
        .update('lista', values, where: 'pk_lista = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('lista', where: 'pk_lista = ?', whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> deleteAllFromList(dynamic id) async {
    Database db = await this.getDb();
    return await db.delete('lista', where: 'fk_fornec = ?', whereArgs: [id]);
  }
}
