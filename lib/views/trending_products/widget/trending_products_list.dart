import 'package:flutter/material.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/views/product_view/product_view.dart';

class TrendingProductsList extends StatelessWidget {
  const TrendingProductsList({super.key, required this.trendingProductsModel});

  final TrendingProductsModel trendingProductsModel;

  @override
  Widget build(BuildContext context) {
    final product = trendingProductsModel.data;

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Trending Products",style: commonTextStyle(color: appColors.primary,fontSize: 18,fontFamily: Fonts.fontSemiBold),)),
          8.sBh,
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Adjusted for 3:4 aspect ratio
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: product.length,
            itemBuilder: (_, index) {
              return commonProductCard(product: product[index].toProduct(),onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(productId: product[index].id),));
              },);
            },
          ),
        ],
      ),
    );
  }
}