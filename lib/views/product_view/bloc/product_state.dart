// product_page_state.dart
abstract class ProductPageState {}

class ProductPageInitial extends ProductPageState {}
class ProductPageLoading extends ProductPageState {}

class ProductPageLoaded extends ProductPageState {}

class ProductPageError extends ProductPageState {
  final String message;
  ProductPageError(this.message);
}

// Usage example in your widget:
/*
class ProductPage extends StatelessWidget {
  final String productId;
  
  const ProductPage({Key? key, required this.productId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductPageCubit(
        context.read<ProductApiService>()
      )..fetchProduct(productId),
      child: BlocBuilder<ProductPageCubit, ProductPageState>(
        builder: (context, state) {
          if (state is ProductPageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductPageLoaded) {
            return ProductView(product: state.product);
          } else if (state is ProductPageError) {
            return ErrorView(message: state.message);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
*/