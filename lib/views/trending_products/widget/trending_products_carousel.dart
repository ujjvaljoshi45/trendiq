import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trendiq/common/common_carousel_indicator.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

class TrendingProductsCarousel extends StatefulWidget {
  const TrendingProductsCarousel({
    super.key,
    required this.trendingProductsModel,
  });

  final TrendingProductsModel trendingProductsModel;

  @override
  State<TrendingProductsCarousel> createState() =>
      _TrendingProductsCarouselState();
}

class _TrendingProductsCarouselState extends State<TrendingProductsCarousel> {
  final ValueNotifier<int> currentCarouselIndicator = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final banners = widget.trendingProductsModel.banner;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: List.generate(
            banners.length,
            (index) => InkWell(
              onTap: () => ToastService().showToast("Tapped", seconds: 200),
              child: CachedNetworkImage(
                imageUrl: banners[index].mobileImage,
                width: double.infinity,
                fit: BoxFit.cover
              ),
            ),
          ),
          options: CarouselOptions(
            aspectRatio: 3/4,
            viewportFraction: 1.0,
            onPageChanged:
                (index, reason) => currentCarouselIndicator.value = index,
            autoPlay: true,
            enlargeCenterPage: false,
            pageSnapping: true,
          ),
        ),
        10.sBh,
        CommonCarouselIndicator(
          length: banners.length,
          controller: currentCarouselIndicator,
        ),
      ],
    );
  }
}
