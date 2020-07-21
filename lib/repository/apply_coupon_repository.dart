import 'package:charliechang/models/apply_coupon_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class ApplyCouponRepository
{
  ApiProvider _provider = ApiProvider();
  Future<ApplyCouponReponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("cart/coupon/check",bodyData);
    return ApplyCouponReponse.fromJson(response);
  }
}