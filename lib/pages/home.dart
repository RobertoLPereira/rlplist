import 'package:flutter/material.dart';
import 'package:thizerlist/blocs/home_fornec_bloc.dart';
import 'package:thizerlist/blocs/home_list_bloc.dart';
import '../layout.dart';
// ignore: unused_import
import '../layoutFornec.dart';
import '../widgets/HomeFornec.dart';
import '../widgets/HomeList.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final HomeListBloc listaBloc = HomeListBloc();
  final HomeFornecBloc listaFornecBloc = HomeFornecBloc();

  @override
  void dispose() {
    listaBloc.dispose();
    // listaFornecBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = StreamBuilder<List<Map>>(
      stream: listaBloc.lists, //listaFornecBloc.getFornec(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: Text('Carregando...'));
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            } else {
              return HomeFornec(
                lists: snapshot.data,
                fornecBloc: this.listaFornecBloc,
              );
            }
        }
      },
    );

    return LayoutFornec.getContent(context, content);
  }
}
