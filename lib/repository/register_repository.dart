import 'package:charliechang/models/register_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';


class RegisterRepository {
  ApiProvider _provider = ApiProvider();
  Future<RegisterResponse> fetchRegisterResponse(var bodyData) async {
    final response = await _provider.post("registration",bodyData);
    return RegisterResponse.fromJson(response);
  }
}