import 'package:charliechang/models/apply_loyalty_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class ApplyLoyaltyRepository
{
  ApiProvider _provider = ApiProvider();
  Future<ApplyLoyaltyResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("cart/loyaltyapply",bodyData);
    return ApplyLoyaltyResponse.fromJson(response);
  }
}