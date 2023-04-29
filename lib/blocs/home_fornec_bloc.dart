import 'dart:async';

import 'package:thizerlist/models/fornec.dart';

class HomeFornecBloc {
  HomeFornecBloc() {
    getFornec();
  }

  ModelFornec fornecBo = ModelFornec();

  final _controller = StreamController<List<Map>>.broadcast();

  get fornecs => _controller.stream;

  dispose() {
    _controller.close();
  }

  getFornec() async {
    _controller.sink.add(await fornecBo.list());
  }
}
