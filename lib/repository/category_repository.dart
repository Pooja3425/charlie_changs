import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class CategoryRepository
{
  ApiProvider _provider = ApiProvider();
  Future<CategoryRespose> fetchResponse(String url) async {
    //final response = await _provider.getHeader("shop/category");
    final response = await _provider.getHeader(url);
    // final response = await _provider.getHeader("super_category_list");
    return CategoryRespose.fromJson(response);
  }
}