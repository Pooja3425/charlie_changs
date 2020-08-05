import 'dart:async';

import 'package:charliechang/models/notification_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/notification_repository.dart';

class NotificationBloc
{
  NotificationRepository _notificationRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<NotificationResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<NotificationResponse>> get dataStream =>
      _regDataController.stream;

  NotificationBloc() {
    _regDataController = StreamController<Response<NotificationResponse>>();
    _notificationRepository = NotificationRepository();
    _isStreaming = true;
    fetchRegisterData();
  }

  fetchRegisterData() async {
    dataSink.add(Response.loading('Loading...'));
    try {
      NotificationResponse regRes = await _notificationRepository.fetchResponse();
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