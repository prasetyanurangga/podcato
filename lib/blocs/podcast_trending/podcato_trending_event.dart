import 'package:equatable/equatable.dart';

abstract class PodcastTrendingEvent extends Equatable {
  const PodcastTrendingEvent();
  @override
  List<Object> get props => [];
}

class GetTrendingPodcast extends PodcastTrendingEvent {
  final String? category;
  const GetTrendingPodcast(this.category);
}
