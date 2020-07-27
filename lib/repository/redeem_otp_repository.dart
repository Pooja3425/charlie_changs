import 'package:charliechang/models/redeem_otp_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class RedeemOTPRepository
{
  ApiProvider _provider = ApiProvider();
  Future<RedeemOTPResponse> fetchResponse(var bodyData) async {
    final response = await _provider.post("cart/redeem_reward",bodyData);
    return RedeemOTPResponse.fromJson(response);
  }
}