import 'dart:async';

import 'package:charliechang/models/loyalty_points_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/loyalty_points_repository.dart';

class LoyaltyPointsBloc
{
  LoyaltyPointsRepository _loyaltyPointsRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<LoyaltyPointsResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<LoyaltyPointsResponse>> get dataStream =>
      _regDataController.stream;

  LoyaltyPointsBloc() {
    _regDataController = StreamController<Response<LoyaltyPointsResponse>>();
    _loyaltyPointsRepository = LoyaltyPointsRepository();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      LoyaltyPointsResponse regRes = await _loyaltyPointsRepository.fetchResponse();
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
