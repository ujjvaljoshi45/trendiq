import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/search_view/bloc/search_bloc.dart';
import 'package:trendiq/views/search_view/filter_sheet.dart';
import 'package:trendiq/views/search_view/product_page.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({super.key});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  late final SearchBloc searchBloc;
  late final TrendingProductsBloc trendingProductsBloc;
  int currentPageNo = 1;
  final TextEditingController etSearch = TextEditingController();
  String appBarTitle = "Explore";
  bool isCallApi = true;

  // Sort and Filter variables
  String selectedSortOption = 'Default';
  Map<String, dynamic> activeFilters = {};

  final List<String> sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'Name: Z to A',
    'Newest First',
  ];

  @override
  void initState() {
    trendingProductsBloc = BlocProvider.of<TrendingProductsBloc>(context);
    searchBloc = BlocProvider.of<SearchBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchDataFromNavParams();
      if (isCallApi) {
        searchBloc.add(
          SearchLoadingEvent(
            gender: trendingProductsBloc.isMen ? "male" : "female",
            pageNo: currentPageNo,
            categoryId: "",
            searchKeyword: etSearch.text,
          ),
        );
      }
    });
    super.initState();
  }

  void fetchDataFromNavParams() {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    appBarTitle = args["appBarTitle"] ?? "Explore";
    isCallApi = args["isCallApi"] ?? true;
    setState(() {});
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By',
                  style: commonTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            8.sBh,
            ...sortOptions.map((option) => ListTile(
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(option, style: commonTextStyle(fontSize: 14)),
              trailing: selectedSortOption == option
                  ? Icon(Icons.check, color: appColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  selectedSortOption = option;
                });
                Navigator.pop(context);
                _applySortAndFilter();
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.show(
      context: context,
      initialFilters: activeFilters,
      onFiltersApplied: (filters) {
        setState(() {
          activeFilters = filters;
        });
        _applySortAndFilter();
      },
    );
  }

  void _applySortAndFilter() {
    // Here you would typically call your BLoC event with sort and filter parameters
    searchBloc.add(
      SearchLoadingEvent(
        gender: trendingProductsBloc.isMen ? "male" : "female",
        pageNo: currentPageNo,
        searchKeyword: etSearch.text,
        sortBy: selectedSortOption,
        filters: activeFilters,
      ),
    );
  }

  int get _getActiveFilterCount {
    int count = 0;
    activeFilters.forEach((key, value) {
      if (value is List && value.isNotEmpty) count++;
      if (value is num && key.contains('Price')) count++;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        showBackButton: true,
        title: appBarTitle,
        actions: [
        // Sort Button
        InkWell(
          onTap: _showSortBottomSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: appColors.tertiaryContainer),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort, size: 18, color: appColors.onSurface),
                4.sBw,
                Text(
                  'Sort',
                  style: commonTextStyle(fontSize: 14,color: appColors.onSurface),
                ),
              ],
            ),
          ),
        ),
        8.sBw,
        // Filter Button
        InkWell(
          onTap: _showFilterBottomSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _getActiveFilterCount > 0
                    ? appColors.primary
                    : appColors.tertiaryContainer,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _getActiveFilterCount > 0
                  ? appColors.primary.withOpacity(0.1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 18,
                  color: _getActiveFilterCount > 0
                      ? appColors.primary
                      : appColors.onSurface,
                ),
                4.sBw,
                Text(
                  'Filter',
                  style: commonTextStyle(
                    fontSize: 14,
                    color: _getActiveFilterCount > 0
                        ? appColors.primary
                        : appColors.onSurface,
                  ),
                ),
                if (_getActiveFilterCount > 0) ...[
                  4.sBw,
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: appColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getActiveFilterCount.toString(),
                      style: commonTextStyle(
                        fontSize: 10,
                        color: appColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchErrorState) {
                  return Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        searchBloc.add(SearchLoadingEvent(
                          gender: trendingProductsBloc.isMen ? "male" : "female",
                          pageNo: currentPageNo,
                          searchKeyword: etSearch.text,
                        ));
                      },
                      label: Text("Retry", style: commonTextStyle()),
                      icon: const Icon(Icons.refresh),
                    ),
                  );
                }

                if (state is SearchLoadedState && searchBloc.products.isEmpty) {
                  return Center(child: Text("Ops No Data Found"),);
                }
                if (state is SearchLoadingState || searchBloc.products.isEmpty) {
                  return Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return _buildSkeletonProductCard();
                      },
                      itemCount: 6, // Show 6 skeleton cards
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return commonProductCard(product: searchBloc.products[index],onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return ProductPage(productId: searchBloc.products[index].id);
                      },));
                    },);
                  },
                  itemCount: searchBloc.products.length,
                );
              },
              listener: (context, state) {
                if (state is SearchErrorState) {
                  ToastService().showToast(state.message, isError: true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.tertiaryContainer),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            8.sBh,
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            4.sBh,
            Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
