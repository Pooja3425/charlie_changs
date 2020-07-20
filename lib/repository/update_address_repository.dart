import 'package:charliechang/models/update_address_resonse.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class UpdateAddressRepository
{
  ApiProvider _provider = ApiProvider();
  Future<UpdateAddress> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("update_address",bodyData);
    return UpdateAddress.fromJson(response);
  }
}
