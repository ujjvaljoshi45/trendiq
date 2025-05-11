
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/category_api.dart';
import 'package:trendiq/services/api/product_api.dart';
import 'package:trendiq/services/api/auth_api.dart';
final apiController = _ApiController();

class _ApiController extends Api with UserAuthApis, ProductsApi, CategoryApi {
  _ApiController._();
  static final _instance = _ApiController._();
  factory _ApiController() => _instance;
}