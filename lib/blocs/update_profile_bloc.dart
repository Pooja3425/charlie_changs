import 'dart:async';

import 'package:charliechang/models/update_profile.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/update_profile_repository.dart';

class UpdateProfileBloc
{
  UpdateProfileRepository _updateProfileRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<UpdateProfileResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<UpdateProfileResponse>> get dataStream =>
      _regDataController.stream;

  UpdateProfileBloc(var bodyData) {
    _regDataController = StreamController<Response<UpdateProfileResponse>>();
    _updateProfileRepository = UpdateProfileRepository();
    _isStreaming = true;
    fetchData(bodyData);
  }

  fetchData(var bodyData) async {
    dataSink.add(Response.loading('Updating...'));
    try {
      UpdateProfileResponse regRes = await _updateProfileRepository.fetchResponse(bodyData);
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