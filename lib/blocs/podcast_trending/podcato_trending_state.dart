import 'package:equatable/equatable.dart';
import 'package:podcato/models/response_podcasts_model.dart';

abstract class PodcastTrendingState extends Equatable {
  const PodcastTrendingState();

  @override
  List<Object> get props => [];
}

class PodcastTrendingInitial extends PodcastTrendingState {}

class PodcastTrendingLoading extends PodcastTrendingState {}

class PodcastTrendingSuccess extends PodcastTrendingState {
  final List<Feeds> data;

  const PodcastTrendingSuccess({required this.data});
}


class PodcastTrendingByCategorySuccess extends PodcastTrendingState {
  final List<Feeds> data;

  const PodcastTrendingByCategorySuccess({required this.data});
}

class PodcastTrendingFailure extends PodcastTrendingState {
  final String error;

  const PodcastTrendingFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PodcastFailure { error: $error }';
}
