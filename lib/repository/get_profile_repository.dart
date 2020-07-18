import 'package:charliechang/models/get_profile_data.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class GetProfileRepository
{
  ApiProvider _provider = ApiProvider();
  Future<GetProfileData> fetchResponse() async {
    final response = await _provider.getHeader("profile_details");
    return GetProfileData.fromJson(response);
  }
}