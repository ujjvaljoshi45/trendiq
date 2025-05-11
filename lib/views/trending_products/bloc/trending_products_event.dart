abstract class TrendingProductEvent {}

class LoadTrendingProductEvent extends TrendingProductEvent {
  final String gender;

  LoadTrendingProductEvent({required this.gender});
}
