import 'dart:async';

import 'package:charliechang/models/get_profile_data.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/get_profile_repository.dart';

class GetProfileBloc
{
  GetProfileRepository _getProfileRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<GetProfileData>> get dataSink =>
      _regDataController.sink;

  Stream<Response<GetProfileData>> get dataStream =>
      _regDataController.stream;

  GetProfileBloc() {
    _regDataController = StreamController<Response<GetProfileData>>();
    _getProfileRepository = GetProfileRepository();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      GetProfileData regRes = await _getProfileRepository.fetchResponse();
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