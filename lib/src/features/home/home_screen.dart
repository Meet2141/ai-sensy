import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/features/history/history_screen.dart';
import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_event.dart';
import 'package:aisensy/src/core/bloc/home_state.dart';
import 'package:aisensy/src/features/home/widgets/home_actions.dart';
import 'package:aisensy/src/features/home/widgets/home_item.dart';
import 'package:aisensy/src/features/home/widgets/home_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadPetsEvent()),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade100, Colors.orange.shade100],
            ),
          ),
          child: AppBar(
            title: Text(
              StringConstants.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstants.black, // Title color
              ),
            ),
            backgroundColor: ColorConstants.transparent, // AppBar background color
            actions: [
              IconButton(
                icon: Icon(Icons.history, color: ColorConstants.black), // White icon color
                onPressed: () {
                  final adoptedPets = (context.read<HomeBloc>().state as HomeLoadedState).adoptedPets;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(adoptedPets: adoptedPets),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoadedState) {
            return Column(
              children: [
                HomeSearch(
                  onSearch: (value) {
                    context.read<HomeBloc>().add(SearchPetsEvent(query: value));
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.displayedPets.length,
                    itemBuilder: (context, index) {
                      final pet = state.displayedPets[index];
                      return HomeItem(
                        pet: pet,
                      );
                    },
                  ),
                ),
                HomeActions(
                  currentPage: state.currentPage,
                  totalPets: state.totalPets,
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                StringConstants.noPetsAvailable,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
