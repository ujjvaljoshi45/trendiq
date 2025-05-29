import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/models/product.dart';
import 'package:trendiq/services/api/api_controller.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<Product> products = [];
  int noOfItem = 10;
  SearchBloc() : super(SearchInitial()) {
    on<SearchLoadingEvent>(_handleSearchLoading);

  }

  _handleSearchLoading(SearchLoadingEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    final response= await apiController.getAllProducts({
      Keys.page:event.pageNo.toString(),
      Keys.size: event.pageItem.toString(),
      Keys.search: event.searchKeyword,
      Keys.categoryId:event.categoryId,
      Keys.gender:event.gender,
      Keys.userEmail:event.email,
    });
    if (response.isError || response.data == null) {
      emit(SearchErrorState(response.message));
    } else {
      products = response.data ?? [];
      emit(SearchLoadedState());
    }
  }
}
