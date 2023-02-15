import 'package:bloc/bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_event.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_state.dart';
import 'package:podcato/models/response_detail_podcast_model.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:podcato/providers/response_data.dart';
import 'package:podcato/repositories/main_repository.dart';

class DetailPodcastBloc extends Bloc<DetailPodcastEvent, DetailPodcastState> {
  MainRepository mainRepository = MainRepository();

  DetailPodcastBloc() : super(DetailPodcastInitial()) {
    on<GetDetailPodcast>((event, emit) async {
      emit(DetailPodcastLoading());
      try {
        final ResponseData<dynamic> responseEpisode =
            await mainRepository.GetDetailEpisode(event.id);
        final ResponseData<dynamic> responsePodcast =
            await mainRepository.GetDetailPodcast(event.id);
        var finalResponseEpisodes = responseEpisode.data;
        var finalResponsePodcast = responsePodcast.data;
        if (responsePodcast.status == Status.ConnectivityError ||
            responseEpisode.status == Status.ConnectivityError) {
          emit(const DetailPodcastFailure(error: ""));
        }
        if (responseEpisode.status == Status.Success &&
            responsePodcast.status == Status.Success) {
          emit(DetailPodcastSuccess(
              episodes: finalResponseEpisodes.items as List<Items>,
              data: finalResponsePodcast.feed as Feed));
        } else {
          emit(DetailPodcastFailure(error: responseEpisode.message ?? "Error"));
        }
      } catch (error) {
        emit(DetailPodcastFailure(error: error.toString()));
      }
    });
  }
}
