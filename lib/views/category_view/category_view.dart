import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'bloc/category_bloc.dart';
import 'bloc/category_state.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc,CategoryState>(builder: (context, state) {
      return Skeletonizer(
          enabled: state is CategoryLoading,
          child: Text("Category"));
    },);
  }
}
