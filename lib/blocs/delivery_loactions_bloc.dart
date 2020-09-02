import 'dart:async';

import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/delivery_locations_repository.dart';

class DeliveryLocationsBloc
{
  DeliveryLocationsRepository _deliveryLocationsRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<DeliveryLocationsResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<DeliveryLocationsResponse>> get dataStream =>
      _regDataController.stream;

  DeliveryLocationsBloc() {
    _regDataController = StreamController<Response<DeliveryLocationsResponse>>();
    _deliveryLocationsRepository = DeliveryLocationsRepository();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Saving data...'));
    try {
      DeliveryLocationsResponse regRes = await _deliveryLocationsRepository.fetchResponse();
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