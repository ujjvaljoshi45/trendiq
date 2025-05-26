

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {
  final String gender;

  CategoryLoading(this.gender);
}

class CategoryLoaded extends CategoryState {
  CategoryLoaded();
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
