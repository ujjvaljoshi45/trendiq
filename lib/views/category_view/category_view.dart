import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_state.dart';
import 'package:trendiq/views/category_view/widgets/category_card.dart';

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
        if (state is CategoryLoaded) {
          return Column(
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
                          childAspectRatio: 0.75, // Creates vertical rectangle
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
                          // Navigate to category detail
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}