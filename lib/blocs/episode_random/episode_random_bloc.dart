import 'package:bloc/bloc.dart';
import 'package:podcato/blocs/episode_random/episode_random_event.dart';
import 'package:podcato/blocs/episode_random/episode_random_state.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:podcato/providers/response_data.dart';
import 'package:podcato/repositories/main_repository.dart';

class EpidoseRandomBloc extends Bloc<EpidoseRandomEvent, EpidoseRandomState> {
  MainRepository mainRepository = MainRepository();

  EpidoseRandomBloc() : super(EpidoseRandomInitial()) {
    on<GetEpisodeRandom>((event, emit) async {
      emit(EpidoseRandomLoading());
      try {
        final ResponseData<dynamic> response =
            await mainRepository.GetEpisodeRandom();
        var finalResponse = response.data;
        if (response.status == Status.ConnectivityError) {
          emit(const EpidoseRandomFailure(error: ""));
        }
        if (response.status == Status.Success) {
          emit(EpidoseRandomSuccess(
              data: finalResponse.episodes as List<Items>));
        } else {
          emit(EpidoseRandomFailure(error: response.message ?? "Error"));
        }
      } catch (error) {
        emit(EpidoseRandomFailure(error: error.toString()));
      }
    });
  }
}
