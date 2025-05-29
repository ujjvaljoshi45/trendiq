import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/generated/assets.dart';
import 'package:trendiq/models/product.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product product = Product.dummy();
  bool isLoading = true;
  int selectedColorIndex = 0;
  String selectedSize = '';
  int productRating = 4; // Static rating as requested

  @override
  void didChangeDependencies() async {
    final response = await apiController.getSingleProduct({
      Keys.name: widget.productId,
    });
    if (!response.isError && response.data != null) {
      product = response.data!;
      // Initialize selected size with first available size
      if (product.productInventory.isNotEmpty) {
        selectedSize = 'M';
      }
      setState(() {
        isLoading = false;
      });
    } else if (response.isError) {
      ToastService().showToast(response.message, isError: true);
      Navigator.pop(context);
    } else {
      ToastService().showToast("Unable to get Products,", isError: true);
      Navigator.pop(context);
    }
    super.didChangeDependencies();
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

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 8.0,
      children: product.productImages.asMap().entries.map((entry) {
        int index = entry.key;
        var imageData = entry.value;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColorIndex = index;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: selectedColorIndex == index
                  ? Border.all(color: appColors.primary, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(imageData.imageUrl),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 8.0,
      children: product.productInventory.map((inventory) {
        String size = "S";
        bool isSelected = selectedSize == size;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSize = size;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? appColors.primary : appColors.lightGrey,
                width: isSelected ? 2 : 1,
              ),
              color: isSelected ? appColors.primary.withOpacity(0.1) : null,
            ),
            child: Text(
              size,
              style: commonTextStyle(
                color: isSelected ? appColors.primary : null,
                fontFamily: isSelected ? Fonts.fontBold : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsList() {
    // Sample review data
    final reviews = [
      {
        'name': 'Sarah M.',
        'rating': 4,
        'comment': 'Amazing quality and perfect fit! Will definitely buy more.',
        'date': '2025-01-01'
      },
      {
        'name': 'John D.',
        'rating': 5,
        'comment': 'Excellent product, highly recommended!',
        'date': '2024-12-28'
      },
      {
        'name': 'Emma L.',
        'rating': 4,
        'comment': 'Good quality but delivery was a bit slow.',
        'date': '2024-12-25'
      },
    ];

    return Column(
      children: reviews.map((review) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: product.title),
      body: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed Carousel with proper error handling
              Container(
                height: 300,
                child: CarouselSlider(
                  items: product.productImages.isNotEmpty
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
                          placeholder: (context, url) => Container(
                            color: appColors.lightGrey,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: appColors.lightGrey,
                            child: Icon(
                              Icons.error,
                              color: appColors.primary,
                            ),
                          ),
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
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: appColors.primary,
                      ),
                    )
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
                      color: appColors.lightGrey,
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
              _buildColorSelector(),

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
              _buildSizeSelector(),

              20.sBh,

              // Stock status
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
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart logic
                    ToastService().showToast("Added to cart!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Add To Cart",
                    style: commonTextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: Fonts.fontBold,
                    ),
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
                style: commonTextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
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
  }
}