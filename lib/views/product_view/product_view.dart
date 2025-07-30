import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/storage_service.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/product_view/bloc/product_cubit.dart';
import 'package:trendiq/views/product_view/bloc/product_state.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final bool isFromCart;

  const ProductPage({
    super.key,
    required this.productId,
    this.isFromCart = false,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int productRating = 4; // Static rating as requested

  Future<void> addToCart({
    required String productId,
    required String inventoryId,
  }) async {
    if (StorageService().getToken().isEmpty) {
      toast("Login to access cart", isInformation: true);
      return;
    }

    final response = await apiController.addToCart({
      "productId": productId,
      "inventoryId": inventoryId,
      "quantity": 1,
    });

    toast(response.message, isError: response.isError);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductPageCubit()..fetchProduct(widget.productId),
      child: BlocConsumer<ProductPageCubit, ProductPageState>(
        listener: (context, state) {
          if (state is ProductPageError) {
            toast(state.message, isError: true);
          }
        },
        builder: (context, state) {
          final productCubit = BlocProvider.of<ProductPageCubit>(context);
          final product = productCubit.product;
          return Scaffold(
            appBar: CommonAppBar(title: product.title, showBackButton: true),
            body: Skeletonizer(
              enabled: state is ProductPageLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: CarouselSlider(
                        items:
                            product.productImages.isNotEmpty
                                ? product.productImages.map((imageData) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: imageData.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder:
                                            (context, url) => Container(
                                              color: appColors.lightGrey,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            color: appColors.lightGrey,
                                            child: Icon(
                                              Icons.error,
                                              color: appColors.primary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                                : [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: appColors.lightGrey,
                                    ),
                                    child: Center(
                                      child: Text("No Image Found"),
                                    ),
                                  ),
                                ],
                        options: CarouselOptions(
                          height: 300,
                          aspectRatio: 1.2,
                          autoPlay: product.productImages.length > 1,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                    20.sBh,
                    // Product title and category
                    Text(
                      product.title,
                      style: commonTextStyle(
                        fontSize: 24,
                        fontFamily: Fonts.fontBold,
                      ),
                    ),
                    6.sBh,
                    Text(
                      product.category.name,
                      style: commonTextStyle(
                        color: appColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    12.sBh,
                    // Rating and reviews
                    Row(
                      children: [
                        _buildStarRating(productRating),
                        8.sBw,
                        Text(
                          "(128 Reviews)",
                          style: commonTextStyle(
                            color: appColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    20.sBh,
                    // Color selection
                    Text(
                      "Color",
                      style: commonTextStyle(
                        fontSize: 16,
                        fontFamily: Fonts.fontBold,
                      ),
                    ),
                    8.sBh,
                    _buildColorSelector(cubit: productCubit),
                    20.sBh,
                    // Size selection
                    Text(
                      "Size",
                      style: commonTextStyle(
                        fontSize: 16,
                        fontFamily: Fonts.fontBold,
                      ),
                    ),
                    8.sBh,
                    _buildSizeSelector(cubit: productCubit),
                    20.sBh,
                    // Stock status
                    if (!product.isStockAvailable(productCubit.selectedSize))
                      Text(
                        "In Stock",
                        style: commonTextStyle(
                          color: Colors.green,
                          fontFamily: Fonts.fontBold,
                        ),
                      ),
                    24.sBh,
                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      child:
                          productCubit.product.id == "-1"
                              ? SizedBox()
                              : ElevatedButton(
                                onPressed:
                                    product.isStockAvailable(
                                          productCubit.selectedSize,
                                        )
                                        ? null
                                        : () async {
                                          if (checkAuthStatus()) {
                                            return;
                                          }
                                          if (product.isAddedToCart(
                                            productCubit.selectedSize,
                                          )) {
                                            widget.isFromCart
                                                ? Navigator.pop(context)
                                                : Navigator.pushNamed(
                                                  context,
                                                  RoutesKey.cart,
                                                );
                                          } else {
                                            if (productCubit.selectedSize < 0) {
                                              toast(
                                                "Please Select Size",
                                                isError: true,
                                              );
                                              return;
                                            }
                                            await addToCart(
                                              productId:
                                                  productCubit.product.id,
                                              inventoryId:
                                                  productCubit
                                                      .product
                                                      .productInventory[productCubit
                                                          .selectedSize]
                                                      .id,
                                            );
                                            Navigator.pushReplacementNamed(
                                              context,
                                              RoutesKey.cart,
                                            );
                                          }
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appColors.primary,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  getElevatedButtonText(productCubit),
                                  style: commonTextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: Fonts.fontBold,
                                  ),
                                ),
                              ),
                    ),
                    12.sBh,
                    Center(
                      child: TextButton.icon(
                        onPressed: () async {
                          if (checkAuthStatus()) {
                            return;
                          }
                          final response =
                              product.isInWishlist()
                                  ? await apiController.removeFromWishList(
                                    product.wishlist.firstOrNull?.id ?? "",
                                  )
                                  : await apiController.addToWishList({
                                    "productId": product.id,
                                  });
                          if (response.isError) {
                            toast(response.message, isError: true);
                          } else {
                            productCubit.fetchProduct(product.id);
                          }
                        },
                        label: Text(
                          product.isInWishlist()
                              ? "Remove From Wishlist"
                              : "Add To Wishlist",
                          style: commonTextStyle(
                            fontFamily: Fonts.fontSemiBold,
                          ),
                        ),
                        icon: Icon(
                          product.isInWishlist()
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: appColors.primary,
                        ),
                      ),
                    ),
                    24.sBh,
                    // Description
                    Text(
                      "Description",
                      style: commonTextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.fontBold,
                      ),
                    ),
                    8.sBh,
                    Text(
                      product.description,
                      style: commonTextStyle(fontSize: 14, height: 1.5),
                    ),

                    24.sBh,

                    // Reviews section
                    Text(
                      "Reviews",
                      style: commonTextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.fontBold,
                      ),
                    ),
                    16.sBh,
                    _buildReviewsList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(int rating, {double size = 20.0}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_outline,
          color: appColors.primary,
          size: size,
        );
      }),
    );
  }

  Widget _buildColorSelector({required ProductPageCubit cubit}) {
    return Wrap(
      spacing: 8.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children:
          cubit.product.availableColors.asMap().entries.map((entry) {
            var imageData = entry.value;
            bool isSelected = imageData.id == cubit.selectedColorId;
            return GestureDetector(
              onTap: () {
                cubit.selectColor(imageData.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      isSelected
                          ? Border.all(
                            color: appColors.primary.withValues(alpha: 0.4),
                            width: 2,
                          )
                          : null,
                ),
                padding: EdgeInsets.all(isSelected ? 2 : 0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    imageData.imageUrl,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSizeSelector({required ProductPageCubit cubit}) {
    return Wrap(
      spacing: 8.0,
      children: [
        for (int i = 0; i < cubit.product.productInventory.length; i++)
          GestureDetector(
            onTap: () {
              cubit.selectSize(i);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      i == cubit.selectedSize
                          ? appColors.primary
                          : appColors.lightGrey,
                  width: i == cubit.selectedSize ? 2 : 1,
                ),
                color:
                    i == cubit.selectedSize
                        ? appColors.primary.withValues(alpha: 0.1)
                        : null,
              ),
              child: Text(
                cubit.product.productInventory[i].size.name,
                style: commonTextStyle(
                  color: i == cubit.selectedSize ? appColors.primary : null,
                  fontFamily: i == cubit.selectedSize ? Fonts.fontBold : null,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewsList() {
    // Sample review data
    final reviews = [
      {
        'name': 'Sarah M.',
        'rating': 4,
        'comment': 'Amazing quality and perfect fit! Will definitely buy more.',
        'date': '2025-01-01',
      },
      {
        'name': 'John D.',
        'rating': 5,
        'comment': 'Excellent product, highly recommended!',
        'date': '2024-12-28',
      },
      {
        'name': 'Emma L.',
        'rating': 4,
        'comment': 'Good quality but delivery was a bit slow.',
        'date': '2024-12-25',
      },
    ];

    return Column(
      children:
          reviews.map((review) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: appColors.lightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review['name'] as String,
                        style: commonTextStyle(fontFamily: Fonts.fontBold),
                      ),
                      Text(
                        review['date'] as String,
                        style: commonTextStyle(
                          fontSize: 12,
                          color: appColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  4.sBh,
                  _buildStarRating(review['rating'] as int, size: 16),
                  6.sBh,
                  Text(
                    review['comment'] as String,
                    style: commonTextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  String getElevatedButtonText(ProductPageCubit cubit) {
    final product = cubit.product;
    final inventory = cubit.product.productInventory[cubit.selectedSize];

    if (inventory.stock < inventory.minimumStock) {
      return "Out Of Stock";
    }
    if (product.isAddedToCart(cubit.selectedSize)) {
      return "Go To Cart";
    }
    return "Add To Cart";
  }

  bool checkAuthStatus() {
    if (StorageService().getToken().isEmpty) {
      Navigator.pushNamed(context, RoutesKey.login);
      return true;
    }
    return false;
  }
}
