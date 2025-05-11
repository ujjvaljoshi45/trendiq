abstract class ApiConstants {
  // Base Url
  static const String baseUrl = "https://trendiq-backend.onrender.com";

  //region User Auth
  static const String userSignIn = "/api/v1/user/signin";
  static const String userSignUp = "/api/v1/user/signup";
  static const String userGetUserDetails = "/api/v1/user/get-user-details";
  static const String userUpdatePassword = "/api/v1/user/update-password";

  //endregion

  //region User Products
  static const String userProduct = "/api/v1/user/product";
  static const String userProductTrending = "/api/v1/user/product/trending/home";
  //endregion

  //region User Cart
  static const String userCart = "/api/v1/user/cart";

  //endregion

  //region User Address
  static const String userAddress = "/api/v1/user/address";
  static const String userAddressDefault = "/api/v1/user/address/default";

  //endregion
  //region User Wishlist
  static const String userWishlist = "/api/v1/user/wishlist";

  //endregion

  //region User Category
  static const String userCategory = "/api/v1/user/category";

  //endregion
  static const String userSupport = "/api/v1/user/support";
}
