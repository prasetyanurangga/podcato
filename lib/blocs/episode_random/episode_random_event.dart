import 'package:equatable/equatable.dart';

abstract class EpidoseRandomEvent extends Equatable {
  const EpidoseRandomEvent();
  @override
  List<Object> get props => [];
}

class GetEpisodeRandom extends EpidoseRandomEvent {
  const GetEpisodeRandom();
}
