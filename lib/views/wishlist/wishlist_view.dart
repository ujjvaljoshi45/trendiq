import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/empty_bag_view.dart';
import 'package:trendiq/services/storage_service.dart';
import 'package:trendiq/views/product_view/product_view.dart';
import 'package:trendiq/views/wishlist/bloc/wishlist_bloc.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  late final WishlistBloc wishlistBloc;

  @override
  void initState() {
    wishlistBloc = BlocProvider.of<WishlistBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (StorageService().getToken().isNotEmpty) {
        wishlistBloc.add(WishlistLoadEvent());
      } else {
        wishlistBloc.wishlist = [];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state is WishlistErrorState) {
          return Center(child: Text("Unknown Error Occurred"));
        }
        if (state is! WishlistLoadingState && wishlistBloc.wishlist.isEmpty) {
          return EmptyBagView(
            title: "Your wishlist is empty",
            subtitle:
                "Looks like you haven't added any items to your wishlist yet.",
            onPressed: null,
          );
        }
        return Skeletonizer(
          enabled: state is WishlistLoadingState,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return commonWishlistProductCard(
                title: wishlistBloc.wishlist[index].products?.title ?? "-",
                imageUrl: wishlistBloc.wishlist[index].products?.imageUrl ?? "",
                onTap: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductPage(
                              productId: wishlistBloc.wishlist[index].productId,
                            );
                          },
                        ),
                      )
                      .whenComplete(() {
                        wishlistBloc.add(WishlistLoadEvent());
                      });
                },
              );
            },
            itemCount: wishlistBloc.wishlist.length,
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
