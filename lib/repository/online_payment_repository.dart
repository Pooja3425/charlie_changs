import 'package:charliechang/models/online_payment_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class OnlinePaymentRepository
{
  ApiProvider _provider = ApiProvider();
  Future<OnlinePaymentResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("add_order",bodyData);
    return OnlinePaymentResponse.fromJson(response);
  }
}