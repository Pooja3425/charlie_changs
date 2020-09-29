import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class AddOrderRepository
{
  ApiProvider _provider = ApiProvider();
  Future<AddOrderResponse> fetchResponse(var bodyData,String url) async {
    final response = await _provider.postToken(url,bodyData);
    return AddOrderResponse.fromJson(response);
  }
}
