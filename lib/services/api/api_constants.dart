abstract class ApiConstants {
  // Base Url
  static const String baseUrl = "https://trendiq-be.vercel.app";

  //region User Auth
  static const String userSignIn = "/api/v1/user/signin";
  static const String userSignUp = "/api/v1/user/signup";
  static const String userGetUserDetails = "/api/v1/user/get-user-details";
  static const String userUpdatePassword = "/api/v1/user/update-password";

  //endregion

  //region User Products
  static const String userProduct = "/api/v1/user/product";
  static const String userProductTrending =
      "/api/v1/user/product/trending/home";

  //endregion

  //region User Cart
  static const String userCart = "/api/v1/user/cart";
  static const String userCartCount = "/api/v1/user/cart/count";

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

  // Configs
  static const String configs = "/api/v1/private-res/configs";

  //region Stripe
  static const String stripCreatePaymentIntent =
      "/api/v1/user/stripe/create-payment-intent";
  static const String stripCreatePaymentIntentMobile =
      "/api/v1/user/stripe/create-payment-intent-mobile";
  static const String stripCompletePayment =
      "/api/v1/user/stripe/complete-payment";
  static const String stripCompletePaymentMobile =
      "/api/v1/user/stripe/complete-payment-mobile";
  static const String stripMyOrders = "/api/v1/user/stripe/myorders";
  static const String stripOrdersById = "/api/v1/user/stripe/order/";
}
