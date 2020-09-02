import 'package:charliechang/models/update_profile.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class UpdateProfileRepository
{
  ApiProvider _provider = ApiProvider();
  Future<UpdateProfileResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("update_profile",bodyData);
    return UpdateProfileResponse.fromJson(response);
  }
}