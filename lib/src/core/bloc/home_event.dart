import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPetsEvent extends HomeEvent {}

class SearchPetsEvent extends HomeEvent {
  final String query;

  SearchPetsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class AdoptPetEvent extends HomeEvent {
  final int petId;

  AdoptPetEvent({required this.petId});

  @override
  List<Object?> get props => [petId];
}

class ChangePageEvent extends HomeEvent {
  final int page;

  ChangePageEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class ViewAdoptedPetsEvent extends HomeEvent {}