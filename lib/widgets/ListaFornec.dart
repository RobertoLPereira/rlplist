import 'package:flutter/material.dart';
import 'package:thizerlist/blocs/home_list_bloc.dart';
import 'package:thizerlist/layout.dart';
import 'package:thizerlist/models/Lista.dart';
import 'package:thizerlist/pages/item-edit.dart';

class ListasFornec extends StatefulWidget {
  final List<Map> listas;
  final String filter;
  final HomeListBloc listFornecBloc;

  const ListasFornec({
    Key key,
    this.listas,
    this.filter,
    this.listFornecBloc,
  }) : super(key: key);

  @override
  _ListasFornecState createState() => _ListasFornecState();
}

class _ListasFornecState extends State<ListasFornec> {
  @override
  Widget build(BuildContext context) {
    // Item default
    if (widget.listas.isEmpty) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(title: Text('Nenhuma lista para exibir ainda')),
        ],
      );
    }

    // The list after filter apply
    // ignore: deprecated_member_use
    List<Map> filteredList = List<Map>();

    // There is some filter?
    if (widget.filter.isNotEmpty) {
      for (dynamic lista in widget.listas) {
        // Check if theres this filter in the current item
        String name = lista['name'].toString().toLowerCase();
        if (name.contains(widget.filter.toLowerCase())) {
          filteredList.add(lista);
        }
      }
    } else {
      filteredList.addAll(widget.listas);
    }

    // Empty after filters
    if (filteredList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(title: Text('Nenhuma lista encontrada...')),
        ],
      );
    }

    // Instancia model
    ModelLista listaBo = ModelLista();

    return ListView.builder(
        shrinkWrap: true,
        itemCount: filteredList.length,
        itemBuilder: (BuildContext context, int i) {
          Map lista = filteredList[i];

          // ignore: unused_local_variable
          String nome = lista['name'];

          return ListTile(
            title: Text(lista['name']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Text('Tem certeza?'),
                      content: Text(
                          'Esta ação irá remover a lista selecionada e não poderá ser desfeita'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Cancelar',
                              style: TextStyle(color: Layout.light())),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        ElevatedButton(
                          child: Text('Remover',
                              style: TextStyle(color: Layout.light())),
                          onPressed: () {
                            listaBo.delete(lista['pk_list']);

                            Navigator.of(ctx).pop();
                            widget.listFornecBloc.getList();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            onTap: () {
              listaBo.getItem(lista['pk_list']).then((Map i) {
                // Adiciona dados do item a pagina
                ItemEditPage.item = i;

                // Abre a pagina
                Navigator.of(context).pushNamed(ItemEditPage.tag);
              });
            },
          );
        });
  }
}
