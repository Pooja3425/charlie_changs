import 'package:charliechang/models/loyalty_points_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class LoyaltyPointsRepository
{
  ApiProvider _provider = ApiProvider();
  Future<LoyaltyPointsResponse> fetchResponse() async {
    final response = await _provider.getHeader("user/loyalty_points");
    return LoyaltyPointsResponse.fromJson(response);
  }
}