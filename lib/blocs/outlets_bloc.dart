import 'dart:async';

import 'package:charliechang/models/outlets_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/outlets_repository.dart';

class OutletsBloc
{
  OutletsRepository _outletsRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<OutletsResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<OutletsResponse>> get dataStream =>
      _regDataController.stream;

  OutletsBloc() {
    _regDataController = StreamController<Response<OutletsResponse>>();
    _outletsRepository = OutletsRepository();
    _isStreaming = true;
    fetchRegisterData();
  }

  fetchRegisterData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      OutletsResponse regRes = await _outletsRepository.fetchResponse();
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