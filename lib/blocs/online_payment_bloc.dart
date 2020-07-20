import 'dart:async';

import 'package:charliechang/models/online_payment_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/online_payment_repository.dart';

class OnlinePaymentBloc
{
  OnlinePaymentRepository _onlinePaymentRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<OnlinePaymentResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<OnlinePaymentResponse>> get dataStream =>
      _regDataController.stream;

  OnlinePaymentBloc(var bodyData) {
    _regDataController = StreamController<Response<OnlinePaymentResponse>>();
    _onlinePaymentRepository = OnlinePaymentRepository();
    _isStreaming = true;
    fetchData(bodyData);
  }

  fetchData(var bodyData) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      OnlinePaymentResponse regRes = await _onlinePaymentRepository.fetchResponse(bodyData);
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
