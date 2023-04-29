import 'dart:convert';

class Fornec {
  dynamic idfornec;
  String name;
  String nomeContato;
  String tel;
  String created;

  Fornec({this.idfornec, this.name, this.nomeContato, this.tel, this.created});
  Map<String, dynamic> toMap() {
    return {
      'idfornec': idfornec,
      'name': name,
      'nomeContato': nomeContato,
      'tel': tel,
      'created': created,
    };
  }

  factory Fornec.fromMap(Map<String, dynamic> map) {
    return Fornec(
      idfornec: map['idfornec'],
      name: map['name'],
      nomeContato: map['nomeContato'],
      tel: map['tel'],
      created: map['created'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Fornec.fromJson(String source) => Fornec.fromMap(json.decode(source));
  @override
  String toString() {
    return 'Fornec(idfornec:$idfornec,name:$name,$nomeContato:nomeContato,$tel:tel,created:$created,)';
  }
}
