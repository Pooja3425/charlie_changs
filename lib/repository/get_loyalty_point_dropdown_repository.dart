import 'package:charliechang/models/get_loyalty_points_dropdown.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class GetLoyaltyPointsRepository
{
  ApiProvider _provider = ApiProvider();
  Future<GetLoyaltyPointsDropdown> fetchResponse(var bodyData) async {
    final response = await _provider.post("user/getloyaltypoint",bodyData);
    return GetLoyaltyPointsDropdown.fromJson(response);
  }
}