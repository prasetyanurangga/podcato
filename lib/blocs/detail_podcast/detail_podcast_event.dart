import 'package:equatable/equatable.dart';

abstract class DetailPodcastEvent extends Equatable {
  const DetailPodcastEvent();
  @override
  List<Object> get props => [];
}

class GetDetailPodcast extends DetailPodcastEvent {
  final String id;
  const GetDetailPodcast({required this.id});
}
