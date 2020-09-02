import 'dart:async';

import 'package:charliechang/models/apply_loyalty_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/apply_loyalty_repository.dart';

class ApplyLoyaltyBloc
{
  ApplyLoyaltyRepository _applyLoyaltyRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<ApplyLoyaltyResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<ApplyLoyaltyResponse>> get dataStream =>
      _regDataController.stream;

  ApplyLoyaltyBloc(var bodyData) {
    _regDataController = StreamController<Response<ApplyLoyaltyResponse>>();
    _applyLoyaltyRepository = ApplyLoyaltyRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      ApplyLoyaltyResponse regRes = await _applyLoyaltyRepository.fetchResponse(bodyData);
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