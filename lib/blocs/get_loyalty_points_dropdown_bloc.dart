import 'dart:async';

import 'package:charliechang/models/get_loyalty_points_dropdown.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/get_loyalty_point_dropdown_repository.dart';

class GetLoyaltyPointsBloc
{
  GetLoyaltyPointsRepository _loyaltyPointsRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<GetLoyaltyPointsDropdown>> get dataSink =>
      _regDataController.sink;

  Stream<Response<GetLoyaltyPointsDropdown>> get dataStream =>
      _regDataController.stream;

  GetLoyaltyPointsBloc(var bodyData) {
    _regDataController = StreamController<Response<GetLoyaltyPointsDropdown>>();
    _loyaltyPointsRepository = GetLoyaltyPointsRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      GetLoyaltyPointsDropdown regRes = await _loyaltyPointsRepository.fetchResponse(bodyData);
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