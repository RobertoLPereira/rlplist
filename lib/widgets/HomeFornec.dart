import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thizerlist/blocs/home_fornec_bloc.dart';
import 'package:thizerlist/models/Lista.dart';

import '../layout.dart';
import '../models/Fornec.dart';
import '../models/Item.dart';
import '../pages/home.dart';
import '../pages/items.dart';

import 'dart:async';

enum FornecAction { edit, clone, delete }

class HomeFornec extends StatefulWidget {
  final List<Map> lists;
  final HomeFornecBloc fornecBloc;

  HomeFornec({this.lists, this.fornecBloc}) : super();

  @override
  _HomeFornecState createState() => _HomeFornecState();
}

class _HomeFornecState extends State<HomeFornec> {
  ModelFornec fornecBo = ModelFornec();
  ModelLista listBo = ModelLista();
  ModelItem itemBo = ModelItem();

  @override
  Widget build(BuildContext context) {
    // Item default
    if (widget.lists.length == 0) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Nenhum lista cadastrada ainda...'),
          )
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm');

    return ListView.builder(
      itemCount: widget.lists.length,
      itemBuilder: (BuildContext context, int index) {
        Map list = widget.lists[index];

        var wnome = list['nomeFornec'] ?? 'Não Cadastrado';
        var tel = list['tel'];
        if (list['tel'] == null) tel = 'sem tel ';
        DateTime created = DateTime.tryParse(list['created']);

        return Dismissible(
          key: Key(list['pk_lista'].toString()),
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDeleteDialog(context, list);
            }
            return false;
          },
          onDismissed: (direction) async {
            // First of all we delete all items from this list
            await listBo.deleteAllFromList(list['fk_fornec']);

            // Then delete the list itself
            await fornecBo.delete(list['pk_fornec']);

            // Update list
            widget.fornecBloc.getFornec();
          },
          child: ListTile(
            leading: Icon(Icons.shopping_cart,
                size: 42, color: Layout.secondary(0.6)),
            title: Text(wnome + ' - ' + list['name'] + ' - ' + tel),
            subtitle: Text(
              '(' +
                  list['qtdItems'].toString() +
                  ' itens) - ' +
                  df.format(created),
            ),
            trailing: PopupMenuButton<FornecAction>(
              onSelected: (FornecAction result) async {
                switch (result) {
                  case FornecAction.edit:
                    showEditDialog(context, list);
                    break;
                  case FornecAction.delete:
                    showDeleteDialog(context, list);
                    break;
                  case FornecAction.clone:

                    // Cria a nova lista
                    int newId = await fornecBo.insert(
                      {
                        'name': list['name'] + ' (cópia)',
                        'nomeFornec': list['nomeFornec'],
                        'tel': list['tel'],
                        'created': DateTime.now().toString()
                      },
                    );

                    // Recupera a lista de items dessa lista
                    List<Map> listItems = await listBo.listsByList(
                      list['pk_fornec'],
                      ListsListOrderBy.alphaASC,
                      ListsListFilterBy.all,
                    );
                    /*
                    List<Map> listItems = await itemBo.itemsByList(
                      list['pk_lista'],
                      ItemsListOrderBy.alphaASC,
                      ItemsListFilterBy.all,
                    );
                    */
                    for (Map listItem in listItems) {
                      await listBo.insert({
                        'fk_fornec': newId,
                        'name': listItem['name'],
                        'created': DateTime.now().toString()
                      });
                    }

                    widget.fornecBloc.getFornec();

                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<FornecAction>>[
                  PopupMenuItem<FornecAction>(
                    value: FornecAction.edit,
                    child: Row(children: <Widget>[
                      Icon(Icons.edit, color: Layout.secondary()),
                      Text('Editar',
                          style: TextStyle(color: Layout.secondary()))
                    ]),
                  ),
                  PopupMenuItem<FornecAction>(
                    value: FornecAction.clone,
                    child: Row(children: <Widget>[
                      Icon(Icons.content_copy, color: Layout.secondary()),
                      Text('Duplicar',
                          style: TextStyle(color: Layout.secondary()))
                    ]),
                  ),
                  PopupMenuItem<FornecAction>(
                    value: FornecAction.delete,
                    child: Row(children: <Widget>[
                      Icon(Icons.delete, color: Layout.secondary()),
                      Text('Excluir',
                          style: TextStyle(color: Layout.secondary()))
                    ]),
                  )
                ];
              },
            ),
            onTap: () {
              // Aponta na lista qual esta selecionada
              ItemsPage.pkList = list['pk_lista'];
              ItemsPage.nameList = list['nomeFornec'] + ' - ' + tel;
              // Muda de pagina
              Navigator.of(context).pushNamed(ItemsPage.tag);
            },
          ),
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Map item) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          TextEditingController _cEdit = TextEditingController();
          _cEdit.text = item['nomeFornec'];
          TextEditingController _contato = TextEditingController();
          _contato.text = item['contato'];
          TextEditingController _tel = TextEditingController();
          _tel.text = item['tel'];
          TextEditingController _nomeLista = TextEditingController();
          _nomeLista.text = item['name'];

          final input = TextFormField(
            controller: _cEdit,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Nome',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          );
          final inputContato = TextFormField(
            controller: _contato,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Contato',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          );
          final inputTel = TextFormField(
            controller: _tel,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Tel',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          );
          final inputNomelista = TextFormField(
            controller: _nomeLista,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Nome Orçamento',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          );
          return AlertDialog(
            title: Text('Editar'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  input,
                  inputContato,
                  inputTel,
                  inputNomelista
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child:
                    Text('Cancelar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ElevatedButton(
                child: Text('Salvar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  ModelFornec fornecBo = ModelFornec();

                  fornecBo.update({
                    'nomeFornec': _cEdit.text,
                    'name': _contato.text,
                    'tel': _tel.text,
                    'created': DateTime.now().toString()
                  }, item['fk_fornec']).then((saved) {
                    ModelLista listaBo = ModelLista();
                    listaBo.update({
                      'name': _nomeLista.text,
                      'created': DateTime.now().toString()
                    }, item['pk_lista']);
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> showDeleteDialog(BuildContext context, Map item) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Tem certeza?'),
            content: Container(
              child: Text(
                  'Se você remover esta lista, todos os itens dela serão removidos também e esta ação não poderá ser desfeita.'),
            ),
            actions: <Widget>[
              ElevatedButton(
                child:
                    Text('Cancelar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              ElevatedButton(
                child: Text('Excluir', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  ModelItem itemBo = ModelItem();
                  itemBo.deleteAllFromList(item['pk_lista']);
                  if (item['fk_fornec'] == null) {
                    ModelLista lista = ModelLista();
                    lista.delete(item['pk_lista']);
                  } else {
                    ModelLista lista = ModelLista();
                    lista.deleteAllFromList(item['fk_fornec']);
                    ModelFornec fornec = ModelFornec();
                    fornec.delete(item['fk_fornec']);
                  }
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                },
              )
            ],
          );
        });
  }
}
