import 'package:charliechang/models/notification_response.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class NotificationRepository
{
  ApiProvider _provider = ApiProvider();
  Future<NotificationResponse> fetchResponse() async {
    final response = await _provider.getHeader("get_notification");
    return NotificationResponse.fromJson(response);
  }
}