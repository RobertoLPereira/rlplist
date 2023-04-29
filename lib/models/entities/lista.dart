import 'dart:convert';

class Lista {
  dynamic idfornec;
  dynamic idlista;
  String name;
  String created;

  Lista({this.idfornec, this.idlista, this.name, this.created});
  Map<String, dynamic> toMap() {
    return {
      'idfornec': idfornec,
      'idlista': idlista,
      'name': name,
      'created': created,
    };
  }

  factory Lista.fromMap(Map<String, dynamic> map) {
    return Lista(
      idfornec: map['idfornec'],
      idlista: map['idlista'],
      name: map['name'],
      created: map['created'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Lista.fromJson(String source) => Lista.fromMap(json.decode(source));
  @override
  String toString() {
    return 'Lista(idfornec:$idfornec,idlista:$idlista,name:$name,created:$created,)';
  }
}
