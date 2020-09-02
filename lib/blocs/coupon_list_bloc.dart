import 'dart:async';

import 'package:charliechang/models/coupons_list_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/coupon_list_repository.dart';

class CouponListBloc
{
  CouponListRepository _couponListRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<CouponListResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<CouponListResponse>> get dataStream =>
      _regDataController.stream;

  CouponListBloc() {
    _regDataController = StreamController<Response<CouponListResponse>>();
    _couponListRepository = CouponListRepository();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      CouponListResponse regRes = await _couponListRepository.fetchResponse();
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