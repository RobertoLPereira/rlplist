import 'dart:convert';

class Item {
  dynamic idlista;
  dynamic iditem;
  String name;
  double quantidade;
  dynamic precisao;
  double valor;
  bool checked;
  String created;

  Item(
      {this.idlista,
      this.iditem,
      this.name,
      this.quantidade,
      this.precisao,
      this.valor,
      this.checked,
      this.created});
  Map<String, dynamic> toMap() {
    return {
      'idlista': idlista,
      'iditem': iditem,
      'name': name,
      'quantidade': quantidade,
      'precisao': precisao,
      'valor': valor,
      'checked': checked,
      'created': created,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      idlista: map['idlista'],
      iditem: map['iditem'],
      name: map['name'],
      quantidade: map['quantidade'],
      precisao: map['precisao'],
      valor: map['valor'],
      checked: map['checked'],
      created: map['created'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
  @override
  String toString() {
    return 'Item(idlista:$idlista,iditem:$iditem,name:$name,quantidade:$quantidade,precisao:$precisao,valor:$valor,checked:$checked,created:$created,)';
  }
}
