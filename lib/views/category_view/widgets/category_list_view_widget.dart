import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading || state is CategoryLoaded) {
          return Skeletonizer(
            enabled: state is CategoryLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.primary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore Categories',
                            style: commonTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: appColors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: appColors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                10.sBh,
                CarouselSlider(
                  items: List.generate(
                    categoryBloc.productCategoryModel.data?.length ?? 1,
                    (index) {
                      final category =
                          categoryBloc.productCategoryModel.data?[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              category?.imageUrl ?? "",
                            ),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) => SizedBox(),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    aspectRatio: 1.5,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
