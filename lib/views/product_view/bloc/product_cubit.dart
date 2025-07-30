import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/product.dart';
import 'package:trendiq/services/api/api_controller.dart';
import 'package:trendiq/views/product_view/bloc/product_state.dart';

class ProductPageCubit extends Cubit<ProductPageState> {
  Product product = Product.dummy();
  int selectedSize = 0;
  int productRating = 4; // Static rating as requested
  String selectedColorId = '';
  bool isInStock = true;

  ProductPageCubit() : super(ProductPageLoading()) {
    dispose();
  }

  Future<void> fetchProduct(String productId) async {
    try {
      dispose();
      emit(ProductPageLoading());
      final response = await apiController.getSingleProduct({
        Keys.name: productId,
      });
      if (response.isError || response.data == null) {
        dispose();
        emit(ProductPageError(response.message));
      } else {
        product = response.data!;
        selectedColorId = product.id;
        emit(ProductPageLoaded());
      }
    } catch (error) {
      dispose();
      emit(ProductPageError(error.toString()));
    }
  }

  void selectSize(int index) {
    selectedSize = index;
    emit(ProductPageLoaded());
  }

  void selectColor(String id) async {
    if (selectedColorId == id) {
      return;
    }
    selectedColorId = id;
    fetchProduct(selectedColorId);
  }

  void dispose() {
    product = Product.dummy();
    selectedSize = 0;
    productRating = 4;
  }
}
