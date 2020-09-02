import 'dart:async';

import 'package:charliechang/models/order_history_respons.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/order_history_repository.dart';

class OrderHistoryBloc
{
  OrderHistoryRepository _orderHistoryRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<OrderHistoryResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<OrderHistoryResponse>> get dataStream =>
      _regDataController.stream;

  OrderHistoryBloc() {
    _regDataController = StreamController<Response<OrderHistoryResponse>>();
    _orderHistoryRepository = OrderHistoryRepository();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      OrderHistoryResponse regRes = await _orderHistoryRepository.fetchResponse();
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
