import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/storage_service.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';
import 'package:trendiq/views/home/home_view.dart';
import 'package:trendiq/views/profile/profile_view.dart';
import 'package:trendiq/views/category_view/category_view.dart';
import 'package:trendiq/views/wishlist/wishlist_view.dart';

import '../services/messaging_service.dart';
import 'home/bloc/home_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  late final PageController pageController;
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final List<String> genders = ["male", "female"];
  final ValueNotifier<int> selectedGenderIndex = ValueNotifier(0);

  @override
  void initState() {
    FCMService().getPermissions();
    pageController = BlocProvider.of<HomeBloc>(context).pageController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(LoadHome("male"));
      (StorageService().getToken().isNotEmpty)
          ? BlocProvider.of<CartBloc>(context).add(CartLoadEvent())
          : null;
    });
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
              Navigator.pushNamed(context, RoutesKey.productsList);
            },
            icon: Icon(Icons.search, color: MyColors.primaryColor),
          ),
          buildCartIcon(),
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
        height: 56,
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
      builder: (_, selected, expanded, _) {
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

  Widget buildCartIcon() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final String? cartCount =
            BlocProvider.of<CartBloc>(context).strCartCount;
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  StorageService().getToken().isEmpty
                      ? RoutesKey.login
                      : RoutesKey.cart,
                );
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: MyColors.primaryColor,
              ),
            ),
            if (cartCount != null && cartCount != '0')
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    cartCount.length > 2 ? '99+' : cartCount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
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
