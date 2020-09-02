import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class DeliveryLocationsRepository
{

  ApiProvider _provider = ApiProvider();
  Future<DeliveryLocationsResponse> fetchResponse() async {
    final response = await _provider.getHeader("delivery_location");
    return DeliveryLocationsResponse.fromJson(response);
  }
}