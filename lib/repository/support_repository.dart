import 'package:charliechang/models/support_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class SupportRepository
{
  ApiProvider _provider = ApiProvider();
  Future<SupportResponse> fetchResponse(var bodyData) async {
    final response = await _provider.postToken("feedback",bodyData);
    return SupportResponse.fromJson(response);
  }
}