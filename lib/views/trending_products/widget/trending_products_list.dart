import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

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
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  ToastService().showToast(product[index].title,isInformation: true,seconds: 200);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appColors.tertiaryContainer),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(product[index].imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        8.sBh,
                        Text(
                          product[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: commonTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        4.sBh,
                        commonPriceTag(
                          price: (product[index].productInventory.firstOrNull?.price ?? "-").toString(),
                          strikeOutPrice:
                          ((product[index].productInventory.firstOrNull?.discount ?? 0) > 0)
                              ? (product[index].productInventory.first.price +
                              product[index].productInventory.first.discount)
                              .toString()
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}