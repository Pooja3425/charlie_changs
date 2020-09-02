import 'package:charliechang/models/customer_address_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class CustomerAddressRepository
{
  ApiProvider _provider = ApiProvider();
  Future<CustomerAddressRespose> fetchResponse() async {
    final response = await _provider.getHeader("user/customer_address");
    return CustomerAddressRespose.fromJson(response);
  }
}