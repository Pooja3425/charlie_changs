import 'dart:async';

import 'package:charliechang/models/slider_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/slider_repository.dart';

class SliderBloc
{
  SliderRespository _sliderRespository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<SliderResponse>> get dataSink =>
      _regDataController.sink;

  Stream<Response<SliderResponse>> get dataStream =>
      _regDataController.stream;

  SliderBloc(String url) {
    _regDataController = StreamController<Response<SliderResponse>>();
    _sliderRespository = SliderRespository();
    _isStreaming = true;
    fetchData(url);
  }

  fetchData(String url) async {
    dataSink.add(Response.loading('Loading...'));
    try {
      SliderResponse regRes = await _sliderRespository.fetchResponse(url);
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