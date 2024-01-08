import 'package:equatable/equatable.dart';
import 'package:podcato/models/response_episode_model.dart';

abstract class EpidoseRandomState extends Equatable {
  const EpidoseRandomState();

  @override
  List<Object> get props => [];
}

class EpidoseRandomInitial extends EpidoseRandomState {}

class EpidoseRandomLoading extends EpidoseRandomState {}

class EpidoseRandomSuccess extends EpidoseRandomState {
  final List<Items> data;

  const EpidoseRandomSuccess({required this.data});
}

class EpidoseRandomFailure extends EpidoseRandomState {
  final String error;

  const EpidoseRandomFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PodcastFailure { error: $error }';
}
