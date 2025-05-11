import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/api_constants.dart';

mixin ProductsApi on Api {
  Future<TrendingProductsModel> getUserProductTrending(Map<String,String> jsonData) async {
    final response = await api.get(ApiConstants.userProductTrending,queryParameters: jsonData);
    final result = TrendingProductsModel.fromJson(response.data);

    return result;
  }
}