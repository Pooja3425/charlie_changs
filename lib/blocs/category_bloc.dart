import 'dart:async';

import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/category_repository.dart';

class CategoryBloc
{
  CategoryRepository _categoryRepository;
  StreamController _regDataController;
  bool _isStreaming;

  StreamSink<Response<CategoryRespose>> get dataSink =>
      _regDataController.sink;

  Stream<Response<CategoryRespose>> get dataStream =>
      _regDataController.stream;

  CategoryBloc(String url) {
    _regDataController = StreamController<Response<CategoryRespose>>();
    _categoryRepository = CategoryRepository();
    _isStreaming = true;
    fetchData(url);
  }

  fetchData(String url) async {
    dataSink.add(Response.loading('Getting categories...'));
    try {
      CategoryRespose regRes = await _categoryRepository.fetchResponse(url);
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