abstract class CategoryEvent {}

class CategoryLoadEvent extends CategoryEvent {
  final String gender;
  CategoryLoadEvent(this.gender);
}

class CategoryLoadedEvent extends CategoryEvent {
  final String gender;
  CategoryLoadedEvent(this.gender);
}