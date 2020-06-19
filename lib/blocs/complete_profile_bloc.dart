import 'dart:async';

import 'package:charliechang/models/complete_profile_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/complete_profile_reository.dart';

class CompleteProfieBloc
{
  CompleteProfileRepository _completeProfileRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<CompleteProfileResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<CompleteProfileResponse>> get dataStream =>
      _regDataController.stream;

  CompleteProfieBloc(var bodyData) {
    _regDataController = StreamController<Response<CompleteProfileResponse>>();
    _completeProfileRepository = CompleteProfileRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Saving data...'));
    try {
      CompleteProfileResponse regRes = await _completeProfileRepository.fetchResponse(bodyData);
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