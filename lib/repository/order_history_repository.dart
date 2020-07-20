import 'package:charliechang/models/order_history_respons.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class OrderHistoryRepository
{
  ApiProvider _provider = ApiProvider();
  Future<OrderHistoryResponse> fetchResponse() async {
    final response = await _provider.getHeader("orders");
    return OrderHistoryResponse.fromJson(response);
  }
}