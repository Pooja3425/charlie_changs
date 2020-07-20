import 'dart:async';

import 'package:charliechang/models/update_address_resonse.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/update_address_repository.dart';

class UpdateAddressBloc
{
  UpdateAddressRepository _updateAddressRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<UpdateAddress>> get dataSink =>
      _regDataController.sink;

  Stream<Response<UpdateAddress>> get dataStream =>
      _regDataController.stream;

  UpdateAddressBloc(var bodyData) {
    _regDataController = StreamController<Response<UpdateAddress>>();
    _updateAddressRepository = UpdateAddressRepository();
    _isStreaming = true;
    fetchData(bodyData);
  }

  fetchData(var bodyData) async {
    dataSink.add(Response.loading('Updating...'));
    try {
      UpdateAddress regRes = await _updateAddressRepository.fetchResponse(bodyData);
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