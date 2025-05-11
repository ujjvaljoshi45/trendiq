import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';

mixin CategoryApi on Api {
  Future<void> getCategories(Map<String,String> jsonData) async {
    final response = api.get(ApiConstants.userCategory,queryParameters: jsonData);
    response;
  }
}