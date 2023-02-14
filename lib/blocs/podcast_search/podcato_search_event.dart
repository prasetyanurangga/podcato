import 'package:equatable/equatable.dart';

abstract class PodcastSearchEvent extends Equatable {
  const PodcastSearchEvent();
  @override
  List<Object> get props => [];
}

class SearchPodcast extends PodcastSearchEvent {
  final String query;
  const SearchPodcast({required this.query});
}
