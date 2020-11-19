import 'dart:convert';

import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class MenuReository
{
  ApiProvider _provider = ApiProvider();
  Future<MenuResponse> fetchResponse(var bodyData,String url) async {
    // final response = await _provider.postToken("shop/menu",bodyData);
    final response = await _provider.postToken("shop/menu_common",bodyData);
    return MenuResponse.fromJson(response);
  }
}
