import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_event.dart';
import 'package:trendiq/views/category_view/category_view.dart';
import 'package:trendiq/views/home/bloc/home_bloc.dart';
import 'package:trendiq/views/home/widgets/about_us_tab_bar.dart';
import 'package:trendiq/views/home/widgets/join_us_widget.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_event.dart';

import '../trending_products/trending_product_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController tabController;
  int _currentTabIndex = 0;
  final List<String> genders = ["male", "female"];

  @override
  void initState() {
    tabController = TabController(length: genders.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeBloc>().add(LoadHome("male"));
      // context.read<TrendingProductsBloc>().add(
      //   LoadTrendingProductEvent(gender: "male"),
      // );
    });
    super.initState();
  }

  final ValueNotifier<int> currentCarouselIndicator = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "The Souled Store",
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: MyColors.primaryColor,
            ),
          ),
        ],
      ),

      body: BlocConsumer<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeError) {
            return Text("Ops Something went wrong");
          }
          if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: TabBar(
                      physics: BouncingScrollPhysics(),
                      indicatorColor: context.theme.primaryColor,
                      dividerColor: Colors.grey.shade300,
                      dividerHeight: 2,
                      indicatorAnimation: TabIndicatorAnimation.elastic,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: commonTextStyle(
                        fontFamily: Fonts.fontSemiBold,
                      ),
                      onTap: (value) {
                        if (_currentTabIndex == value) {
                          return;
                        }
                        _currentTabIndex = value;
                        context.read<HomeBloc>().add(
                          LoadHome(genders[_currentTabIndex]),
                        );
                      },
                      controller: tabController,
                      tabs:
                          genders
                              .map(
                                (e) => Tab(text: e == "male" ? "Men" : "Women"),
                              )
                              .toList(),
                    ),
                  ),
                  TrendingProductView(),
                  18.sBh,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: shopByCategoryButton(),
                  ),
                  CategoryView(),
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
          return SizedBox();
        },
        listener: (context, state) {
          if (state is HomeLoading) {
            context.read<TrendingProductsBloc>().add(
              LoadTrendingProductEvent(gender: state.gender),
            );
            context.read<HomeBloc>().add(HomeLoadedEvent(state.gender));
            context.read<CategoryBloc>().add(CategoryLoadEvent(state.gender));
          }
        },
      ),

      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.home_outlined),
                  label: "Home",
                ),
              ),
              Spacer(),
              Flexible(
                child: bottomBarTab(icon: Icon(Icons.search), label: "Search"),
              ),

              Spacer(),
              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.favorite_outline_rounded),
                  label: "Wishlist",
                ),
              ),
              Spacer(),
              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.person_outline_outlined),
                  label: "Profile",
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
