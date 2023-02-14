import 'package:bloc/bloc.dart';
import 'package:podcato/blocs/podcast_search/podcato_search_event.dart';
import 'package:podcato/blocs/podcast_search/podcato_search_state.dart';
import 'package:podcato/models/response_podcasts_model.dart';
import 'package:podcato/providers/response_data.dart';
import 'package:podcato/repositories/main_repository.dart';

class PodcastSearchBloc extends Bloc<PodcastSearchEvent, PodcastSearchState> {
  MainRepository mainRepository = MainRepository();

  PodcastSearchBloc() : super(PodcastSearchInitial()) {
    on<SearchPodcast>((event, emit) async {
      emit(PodcastSearchLoading());
      try {
        final ResponseData<dynamic> response =
            await mainRepository.SearchPodcast(event.query);
        var finalResponse = response.data;
        if (response.status == Status.ConnectivityError) {
          emit(const PodcastSearchFailure(error: ""));
        }
        if (response.status == Status.Success) {
          emit(PodcastSearchSuccess(data: finalResponse.feeds as List<Feeds>));
        } else {
          print(response.message);
          emit(PodcastSearchFailure(error: response.message ?? "Error"));
        }
      } catch (error) {
        print(error);
        emit(PodcastSearchFailure(error: error.toString()));
      }
    });
  }
}
