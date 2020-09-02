import 'dart:async';

import 'package:charliechang/models/redeem_otp_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/redeem_otp_repository.dart';

class RedeemOTPBloc
{
  RedeemOTPRepository _redeemOTPRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<RedeemOTPResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<RedeemOTPResponse>> get dataStream =>
      _regDataController.stream;

  RedeemOTPBloc(var bodyData) {
    _regDataController = StreamController<Response<RedeemOTPResponse>>();
    _redeemOTPRepository = RedeemOTPRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Sending OTP...'));
    try {
      RedeemOTPResponse regRes = await _redeemOTPRepository.fetchResponse(bodyData);
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