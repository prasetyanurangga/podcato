import 'package:bloc/bloc.dart';
import 'package:podcato/blocs/categories/categories_event.dart';
import 'package:podcato/blocs/categories/categories_state.dart';
import 'package:podcato/models/response_categories_model.dart';
import 'package:podcato/providers/response_data.dart';
import 'package:podcato/repositories/main_repository.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  MainRepository mainRepository = MainRepository();

  CategoriesBloc() : super(CategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(CategoriesLoading());
      try {
        final ResponseData<dynamic> responseCategories =
            await mainRepository.GetCategoriesPodcast();
        var finalResponseCategories = responseCategories.data;
        if (responseCategories.status == Status.ConnectivityError ||
            responseCategories.status == Status.ConnectivityError) {
          emit(const CategoriesFailure(error: ""));
        }
        if (responseCategories.status == Status.Success) {
          emit(CategoriesSuccess(
              feed: finalResponseCategories.feeds as List<Feeds>));
        } else {
          emit(CategoriesFailure(error: responseCategories.message ?? "Error"));
        }
      } catch (error) {
        emit(CategoriesFailure(error: error.toString()));
      }
    });
  }
}
