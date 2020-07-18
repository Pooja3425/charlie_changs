import 'dart:async';

import 'package:charliechang/models/support_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/support_repository.dart';

class SupportBloc
{
  SupportRepository _supportRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<SupportResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<SupportResponse>> get dataStream =>
      _regDataController.stream;

  SupportBloc(var bodyData) {
    _regDataController = StreamController<Response<SupportResponse>>();
    _supportRepository = SupportRepository();
    _isStreaming = true;
    fetchData(bodyData);
  }

  fetchData(var bodyData) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      SupportResponse regRes = await _supportRepository.fetchResponse(bodyData);
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