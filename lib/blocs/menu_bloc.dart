import 'dart:async';

import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/menu_repository.dart';

class MenuBloc
{
  MenuReository _menuReository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<MenuResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<MenuResponse>> get dataStream =>
      _regDataController.stream;

  MenuBloc(var bodyData,String url) {
    _regDataController = StreamController<Response<MenuResponse>>();
    _menuReository = MenuReository();
    _isStreaming = true;
    fetchData(bodyData,url);
  }

  fetchData(var bodyData,String url) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      MenuResponse regRes = await _menuReository.fetchResponse(bodyData,url);
      if (_isStreaming) dataSink.add(Response.completed(regRes));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _isStreaming = false;
    _regDataController?.close();
  }

}
