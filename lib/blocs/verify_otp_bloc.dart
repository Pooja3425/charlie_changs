import 'dart:async';

import 'package:charliechang/models/verify_otp_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/verify_otp_repository.dart';

class VerifyOtpBloc
{
  VerifyOtpRepository _registerRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<VerifyOtpResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<VerifyOtpResponse>> get dataStream =>
      _regDataController.stream;

  VerifyOtpBloc(var bodyData) {
    _regDataController = StreamController<Response<VerifyOtpResponse>>();
    _registerRepository = VerifyOtpRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Verifying OTP...'));
    try {
      VerifyOtpResponse regRes = await _registerRepository.fetchResponse(bodyData);
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