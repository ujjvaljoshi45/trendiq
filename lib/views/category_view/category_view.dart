import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_state.dart';
import 'package:trendiq/views/category_view/widgets/category_card.dart';

import '../search_view/bloc/search_bloc.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded || state is CategoryLoading) {
          return Skeletonizer(
            enabled: state is CategoryLoading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                0.75, // Creates vertical rectangle
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                          ),
                      itemCount:
                          categoryBloc.productCategoryModel.data?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category =
                            categoryBloc.productCategoryModel.data?[index];
                        return CategoryCard(
                          name: category?.name ?? "-",
                          imageUrl: category?.imageUrl ?? "-",
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context).add(
                              SearchLoadingEvent(
                                gender: categoryBloc.isMen ? "male" : "female",
                                categoryId: category?.id ?? "empty",
                                pageNo: 1,
                              ),
                            );
                            Navigator.pushNamed(
                              context,
                              RoutesKey.productsList,
                              arguments: {
                                "appBarTitle":
                                    category?.name ??
                                    "Explore"
                                        "",
                                "isCallApi": false,
                              },
                            );
                          },
                        );
                      },
                    ),
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
