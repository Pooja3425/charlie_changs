import 'dart:async';

import 'package:charliechang/models/add_delivery_address_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/add_delivery_address_repository.dart';

class AddDeliveryAddressBloc
{
  AddDeliveryAddressRepository _addDeliveryAddressRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<AddDeliveryAddressRespose>> get dataSink =>
      _regDataController.sink;

  Stream<Response<AddDeliveryAddressRespose>> get dataStream =>
      _regDataController.stream;

  AddDeliveryAddressBloc(var bodyData) {
    _regDataController = StreamController<Response<AddDeliveryAddressRespose>>();
    _addDeliveryAddressRepository = AddDeliveryAddressRepository();
    _isStreaming = true;
    fetchRegisterData(bodyData);
  }

  fetchRegisterData(var bodyData) async {
    dataSink.add(Response.loading('Saving data...'));
    try {
      AddDeliveryAddressRespose regRes = await _addDeliveryAddressRepository.fetchResponse(bodyData);
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