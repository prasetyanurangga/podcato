import 'package:equatable/equatable.dart';
import 'package:podcato/models/response_podcasts_model.dart';

abstract class PodcastSearchState extends Equatable {
  const PodcastSearchState();

  @override
  List<Object> get props => [];
}

class PodcastSearchInitial extends PodcastSearchState {}

class PodcastSearchLoading extends PodcastSearchState {}

class PodcastSearchSuccess extends PodcastSearchState {
  final List<Feeds> data;

  const PodcastSearchSuccess({required this.data});
}

class PodcastSearchFailure extends PodcastSearchState {
  final String error;

  const PodcastSearchFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PodcastFailure { error: $error }';
}
