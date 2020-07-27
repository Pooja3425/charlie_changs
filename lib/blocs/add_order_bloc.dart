import 'dart:async';

import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/add_order_repository.dart';

class AddOrderBloc{
  AddOrderRepository _addOrderRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<AddOrderResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<AddOrderResponse>> get dataStream =>
      _regDataController.stream;

  AddOrderBloc(var bodyData) {
    _regDataController = StreamController<Response<AddOrderResponse>>();
    _addOrderRepository = AddOrderRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Placing your order...'));
    try {
      AddOrderResponse regRes = await _addOrderRepository.fetchResponse(bodyData);
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