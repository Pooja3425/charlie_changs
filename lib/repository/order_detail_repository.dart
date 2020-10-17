import 'package:charliechang/models/order_detail_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class OrderDetailRepository
{
  ApiProvider _provider = ApiProvider();
  Future<Order_Detail_Response> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("cart/redeem_reward",bodyData);
    return Order_Detail_Response.fromJson(response);
  }
}