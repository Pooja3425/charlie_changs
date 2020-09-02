import 'package:charliechang/models/coupons_list_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class CouponListRepository
{
  ApiProvider _provider = ApiProvider();
  Future<CouponListResponse> fetchResponse() async {
    final response = await _provider.getHeader("available_coupan");
    return CouponListResponse.fromJson(response);
  }
}