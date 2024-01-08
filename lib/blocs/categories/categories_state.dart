import 'package:equatable/equatable.dart';
import 'package:podcato/models/response_categories_model.dart';
import 'package:podcato/models/response_detail_podcast_model.dart';
import 'package:podcato/models/response_episode_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final List<Categories> feed;

  const CategoriesSuccess({required this.feed});
}

class CategoriesFailure extends CategoriesState {
  final String error;

  const CategoriesFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PodcastFailure { error: $error }';
}
