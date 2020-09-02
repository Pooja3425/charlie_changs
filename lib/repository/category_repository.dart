import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';

class CategoryRepository
{
  ApiProvider _provider = ApiProvider();
  Future<CategoryRespose> fetchResponse() async {
    final response = await _provider.getHeader("shop/category");
    return CategoryRespose.fromJson(response);
  }
}