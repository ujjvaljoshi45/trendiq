part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchLoadingEvent extends SearchEvent {
  String searchKeyword;
  String categoryId;
  String gender;
  int pageNo;
  int pageItem;
  String email;
  String? sortBy;
  Map<String, dynamic>? filters;

  SearchLoadingEvent({
    this.searchKeyword = "",
    this.categoryId = "",
    this.gender = "male",
    this.pageNo = 1,
    this.pageItem = 10,
    this.email = "",
    this.sortBy,
    this.filters
  });
}

class SearchLoadedEvent extends SearchEvent {}
