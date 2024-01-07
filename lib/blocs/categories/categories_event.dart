import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  List<Object> get props => [];
}

class GetCategories extends CategoriesEvent {
  const GetCategories();
}
