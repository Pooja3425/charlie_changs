import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class AddOrderRepository
{
  ApiProvider _provider = ApiProvider();
  Future<AddOrderResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("add_order",bodyData);
    return AddOrderResponse.fromJson(response);
  }
}
