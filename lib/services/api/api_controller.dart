import 'package:trendiq/services/api/address_api.dart';
import 'package:trendiq/services/api/api.dart';
import 'package:trendiq/services/api/cart_api.dart';
import 'package:trendiq/services/api/category_api.dart';
import 'package:trendiq/services/api/config_api.dart';
import 'package:trendiq/services/api/product_api.dart';
import 'package:trendiq/services/api/auth_api.dart';
import 'package:trendiq/services/api/stripe_api.dart';
import 'package:trendiq/services/api/wishlist_api.dart';

final apiController = _ApiController();

class _ApiController extends Api
    with
        UserAuthApis,
        ProductsApi,
        CategoryApi,
        CartApi,
        AddressApi,
        WishlistApi,
        ConfigApi,
        StripeApi {
  _ApiController._();

  static final _instance = _ApiController._();

  factory _ApiController() => _instance;
}
