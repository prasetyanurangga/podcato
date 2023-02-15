import 'package:equatable/equatable.dart';
import 'package:podcato/models/response_detail_podcast_model.dart';
import 'package:podcato/models/response_episode_model.dart';

abstract class DetailPodcastState extends Equatable {
  const DetailPodcastState();

  @override
  List<Object> get props => [];
}

class DetailPodcastInitial extends DetailPodcastState {}

class DetailPodcastLoading extends DetailPodcastState {}

class DetailPodcastSuccess extends DetailPodcastState {
  final List<Items> episodes;
  final Feed data;

  const DetailPodcastSuccess({required this.data, required this.episodes});
}

class DetailPodcastFailure extends DetailPodcastState {
  final String error;

  const DetailPodcastFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PodcastFailure { error: $error }';
}
