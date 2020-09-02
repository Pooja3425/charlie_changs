import 'dart:async';

import 'package:charliechang/models/register_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/register_repository.dart';

class RegisterBloc
{
  RegisterRepository _registerRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<RegisterResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<RegisterResponse>> get dataStream =>
      _regDataController.stream;

  RegisterBloc(var bodyData) {
    _regDataController = StreamController<Response<RegisterResponse>>();
    _registerRepository = RegisterRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Checking for user...'));
    try {
      RegisterResponse regRes = await _registerRepository.fetchRegisterResponse(bodyData);
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