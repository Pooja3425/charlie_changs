import 'package:charliechang/models/add_delivery_address_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class AddDeliveryAddressRepository
{
  ApiProvider _provider = ApiProvider();
  Future<AddDeliveryAddressRespose> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("user/add_address",bodyData);
    return AddDeliveryAddressRespose.fromJson(response);
  }
}