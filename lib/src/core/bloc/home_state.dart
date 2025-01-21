import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<PetModel> displayedPets;
  final List<PetModel> adoptedPets; // Add adoptedPets here
  final int currentPage;
  final int itemsPerPage;
  final int totalPets;

  HomeLoadedState({
    required this.displayedPets,
    required this.adoptedPets, // Initialize adoptedPets
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalPets,
  });

  @override
  List<Object?> get props => [displayedPets, adoptedPets, currentPage, itemsPerPage, totalPets];
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}