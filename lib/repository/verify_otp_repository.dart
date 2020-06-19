import 'package:charliechang/models/verify_otp_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class VerifyOtpRepository
{
  ApiProvider _provider = ApiProvider();
  Future<VerifyOtpResponse> fetchResponse(var bodyData) async {
    final response = await _provider.post("verify_otp",bodyData);
    return VerifyOtpResponse.fromJson(response);
  }
}