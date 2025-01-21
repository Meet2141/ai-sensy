import 'dart:async';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<PetModel> _allPets = mockPetData;
  List<int> _adoptedPets = [];
  String _searchQuery = "";
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  HomeBloc() : super(HomeInitialState()) {
    on<LoadPetsEvent>(_onLoadPets);
    on<SearchPetsEvent>(_onSearchPets);
    on<AdoptPetEvent>(_onAdoptPet);
    on<ChangePageEvent>(_onChangePage);
    on<ViewAdoptedPetsEvent>(_onViewAdoptedPets);
  }

  Future<void> _onLoadPets(LoadPetsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      _adoptedPets = prefs.getStringList('adoptedPets')?.map(int.parse).toList() ?? [];
      for (var pet in _allPets) {
        pet.adopted = _adoptedPets.contains(pet.id);
      }
      _updateDisplayedPets(emit);
    } catch (e) {
      emit(HomeErrorState(message: "Failed to load pets."));
    }
  }

  void _onSearchPets(SearchPetsEvent event, Emitter<HomeState> emit) {
    _searchQuery = event.query;
    _currentPage = 1;
    _updateDisplayedPets(emit);
  }

  Future<void> _onAdoptPet(AdoptPetEvent event, Emitter<HomeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_adoptedPets.contains(event.petId)) {
      _adoptedPets.add(event.petId);
      await prefs.setStringList('adoptedPets', _adoptedPets.map((e) => e.toString()).toList());
      _allPets.firstWhere((pet) => pet.id == event.petId).adopted = true;
      _updateDisplayedPets(emit); // Update the UI with the latest state
    }
  }

  void _onChangePage(ChangePageEvent event, Emitter<HomeState> emit) {
    _currentPage = event.page;
    _updateDisplayedPets(emit);
  }

  void _onViewAdoptedPets(ViewAdoptedPetsEvent event, Emitter<HomeState> emit) {
    final adoptedPets = _allPets.where((pet) => pet.adopted).toList();
    emit(HomeLoadedState(
      displayedPets: adoptedPets,
      adoptedPets: adoptedPets,
      currentPage: 1,
      itemsPerPage: adoptedPets.length,
      totalPets: adoptedPets.length,
    ));
  }

  void _updateDisplayedPets(Emitter<HomeState> emit) {
    final filteredPets = _allPets
        .where((pet) => _searchQuery.isEmpty || pet.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final displayedPets = filteredPets.skip((_currentPage - 1) * _itemsPerPage).take(_itemsPerPage).toList();
    final adoptedPets = _allPets.where((pet) => pet.adopted).toList(); // Get adopted pets

    emit(HomeLoadedState(
      displayedPets: displayedPets,
      adoptedPets: adoptedPets,
      currentPage: _currentPage,
      itemsPerPage: _itemsPerPage,
      totalPets: filteredPets.length,
    ));
  }
}
