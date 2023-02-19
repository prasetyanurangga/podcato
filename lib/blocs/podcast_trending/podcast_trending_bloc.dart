import 'package:bloc/bloc.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_event.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_state.dart';
import 'package:podcato/models/response_podcasts_model.dart';
import 'package:podcato/providers/response_data.dart';
import 'package:podcato/repositories/main_repository.dart';

class PodcastTrendingBloc
    extends Bloc<PodcastTrendingEvent, PodcastTrendingState> {
  MainRepository mainRepository = MainRepository();

  PodcastTrendingBloc() : super(PodcastTrendingInitial()) {
    on<GetTrendingPodcast>((event, emit) async {
      emit(PodcastTrendingLoading());
      try {
        final ResponseData<dynamic> response =
            await mainRepository.GetTrendingPodcast();
        var finalResponse = response.data;
        if (response.status == Status.ConnectivityError) {
          emit(const PodcastTrendingFailure(error: ""));
        }
        if (response.status == Status.Success) {
          emit(
              PodcastTrendingSuccess(data: finalResponse.feeds as List<Feeds>));
        } else {
          emit(PodcastTrendingFailure(error: response.message ?? "Error"));
        }
      } catch (error) {
        emit(PodcastTrendingFailure(error: error.toString()));
      }
    });
  }
}
