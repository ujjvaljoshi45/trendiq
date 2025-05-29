import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/messaging_service.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_event.dart';
import 'package:trendiq/views/category_view/widgets/category_list_view_widget.dart';
import 'package:trendiq/views/home/bloc/home_bloc.dart';
import 'package:trendiq/views/home/widgets/about_us_tab_bar.dart';
import 'package:trendiq/views/home/widgets/join_us_widget.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_event.dart';
import 'package:trendiq/views/trending_products/trending_product_view.dart';

class HomeView extends StatefulWidget {
  final ValueNotifier<int> selectedGenderIndex;
  const HomeView({super.key, required this.selectedGenderIndex});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  final List<String> genders = ["male", "female"];
  @override
  void initState() {
    super.initState();
    FCMService().getPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(
        LoadHome(genders[widget.selectedGenderIndex.value]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoading) {
          final gender = genders[widget.selectedGenderIndex.value];
          context.read<TrendingProductsBloc>().add(
            LoadTrendingProductEvent(gender: gender),
          );
          context.read<CategoryBloc>().add(CategoryLoadEvent(gender));
          context.read<HomeBloc>().add(HomeLoadedEvent(gender));
        }
      },
      builder: (context, state) {
        if (state is HomeError) {
          return Center(child: Text("Oops! Something went wrong."));
        }
        if (state is HomeLoaded) {
          return SingleChildScrollView(
            key: PageStorageKey("home_scroll"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TrendingProductView(),
                18.sBh,
                CategoryListView(),
                18.sBh,
                SizedBox(
                  height: 330,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AboutUsTabBar(),
                  ),
                ),
                JoinUsWidget(),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
