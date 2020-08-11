import 'package:charliechang/models/slider_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class SliderRespository
{
  ApiProvider _provider = ApiProvider();
  Future<SliderResponse> fetchResponse() async {
    final response = await _provider.getHeader("get_carousal");
    return SliderResponse.fromJson(response);
  }
}