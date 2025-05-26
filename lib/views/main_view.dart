import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/views/home/home_view.dart';
import 'package:trendiq/views/profile/profile_view.dart';
import 'package:trendiq/views/category_view/category_view.dart';
import 'package:trendiq/views/wishlist/wishlist_view.dart';

import '../constants/user_singleton.dart';
import 'home/bloc/home_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  final PageController pageController = PageController();
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final List<String> genders = ["male", "female"];
  final ValueNotifier<int> selectedGenderIndex = ValueNotifier(0);

  @override
  void initState() {
    context.read<HomeBloc>().add(LoadHome("male"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "TrendiQ",
        actions: [
          IconButton(
            onPressed: () {
              final user = UserSingleton().user;
              if (UserSingleton().user == null) {
                Navigator.pushNamed(context, RoutesKey.login);
              } else {
                LogService().logMessage((user?.toJson() ?? " ").toString());
              }
            },
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: MyColors.primaryColor,
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, child) {
          if (value == 0 || value == 1) {
            return buildGenderTabBar();
          } else {
            return SizedBox();
          }
        },
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => currentIndex.value = value,
        children: [
          HomeView(selectedGenderIndex: selectedGenderIndex),
          CategoryView(),
          WishlistView(),
          ProfileView(),
        ],
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
                  onTap: () => pageController.jumpToPage(0),
                ),
              ),
              Spacer(),
              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.space_dashboard_outlined),
                  label: "Category",
                  onTap: () => pageController.jumpToPage(1),
                ),
              ),

              Spacer(),
              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.favorite_outline_rounded),
                  label: "Wishlist",
                  onTap: () => pageController.jumpToPage(2),
                ),
              ),
              Spacer(),
              Flexible(
                child: bottomBarTab(
                  icon: Icon(Icons.person_outline_outlined),
                  label: "Profile",
                  onTap: () => pageController.jumpToPage(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGenderTabBar() {
    final ValueNotifier<bool> isExpanded = ValueNotifier(false);

    return ValueListenableBuilder2<int, bool>(
      first: selectedGenderIndex,
      second: isExpanded,
      builder: (_, selected, expanded, __) {
        return AnimatedCrossFade(
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          firstChild: GestureDetector(
            onTap: () => isExpanded.value = true,
            child: Container(
              height: 46,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                genders[selected] == "male" ? "Men" : "Women",
                style: commonTextStyle(
                  fontFamily: Fonts.fontSemiBold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          secondChild: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(genders.length, (index) {
                final isSelected = selected == index;
                final label = genders[index] == "male" ? "Men" : "Women";

                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? context.theme.primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () {
                          if (selectedGenderIndex.value != index) {
                            selectedGenderIndex.value = index;
                            final selectedGender = genders[index];
                            context.read<HomeBloc>().add(
                              LoadHome(selectedGender),
                            );
                          }
                          isExpanded.value = false;
                        },
                        child: Center(
                          child: Text(
                            label,
                            style: commonTextStyle(
                              fontFamily: Fonts.fontSemiBold,
                              fontSize: 14,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    required this.first,
    required this.second,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, valueA, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, valueB, child) {
            return builder(context, valueA, valueB, child);
          },
        );
      },
    );
  }
}
