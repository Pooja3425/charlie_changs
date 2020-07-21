import 'dart:async';

import 'package:charliechang/models/apply_coupon_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/apply_coupon_repository.dart';

class ApplyCouponBloc
{
  ApplyCouponRepository _applyCouponRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<ApplyCouponReponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<ApplyCouponReponse>> get dataStream =>
      _regDataController.stream;

  ApplyCouponBloc(var bodyData) {
    _regDataController = StreamController<Response<ApplyCouponReponse>>();
    _applyCouponRepository = ApplyCouponRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Applying...'));
    try {
      ApplyCouponReponse regRes = await _applyCouponRepository.fetchResponse(bodyData);
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
