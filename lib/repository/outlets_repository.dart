import 'package:charliechang/models/outlets_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class OutletsRepository{
  ApiProvider _provider = ApiProvider();
  Future<OutletsResponse> fetchResponse() async {
    final response = await _provider.getHeader("outlets");
    return OutletsResponse.fromJson(response);
  }
}