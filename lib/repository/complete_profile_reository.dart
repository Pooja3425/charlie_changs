import 'package:charliechang/models/complete_profile_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class CompleteProfileRepository
{
  ApiProvider _provider = ApiProvider();
  Future<CompleteProfileResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("complete_profile",bodyData);
    return CompleteProfileResponse.fromJson(response);
  }
}