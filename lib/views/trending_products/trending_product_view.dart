import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/models/trending_products_model.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_state.dart';
import 'package:trendiq/views/trending_products/widget/trending_products_carousel.dart';
import 'package:trendiq/views/trending_products/widget/trending_products_list.dart';

class TrendingProductView extends StatelessWidget {
  const TrendingProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingProductsBloc, TrendingProductsState>(
      builder: (context, state) {
        if (state is TrendingProductsError) {
          return SizedBox();
        }
        if (state is TrendingProductsLoading || state is TrendingProductsLoaded) {
          return Skeletonizer(
              enabled: state is TrendingProductsLoading,
              ignoreContainers: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TrendingProductsCarousel(
                    trendingProductsModel:
                    (state is TrendingProductsLoaded)
                        ? state.trendingProductsModel
                        : TrendingProductsModel.dummy(),
                  ),
                  8.sBh,
                  TrendingProductsList(
                    trendingProductsModel:
                    (state is TrendingProductsLoaded)
                        ? state.trendingProductsModel
                        : TrendingProductsModel.dummy(),
                  ),
                ],
        )); }
        return SizedBox();
      },
    );
  }
}
