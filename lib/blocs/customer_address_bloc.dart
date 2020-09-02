import 'dart:async';

import 'package:charliechang/models/customer_address_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/customer_address_repository.dart';

class CustomerAddressBloc
{
  CustomerAddressRepository _customerAddressRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<CustomerAddressRespose>> get dataSink =>
      _regDataController.sink;

  Stream<Response<CustomerAddressRespose>> get dataStream =>
      _regDataController.stream;

  CustomerAddressBloc() {
    _regDataController = StreamController<Response<CustomerAddressRespose>>();
    _customerAddressRepository = CustomerAddressRepository();
    _isStreaming = true;
    fetchRegisterData();
  }

  fetchRegisterData() async {
    dataSink.add(Response.loading('Fetching address...'));
    try {
      CustomerAddressRespose regRes = await _customerAddressRepository.fetchResponse();
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