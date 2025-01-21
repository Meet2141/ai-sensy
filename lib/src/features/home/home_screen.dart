import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:aisensy/src/features/detail/detail_screen.dart';
import 'package:aisensy/src/features/history/history_screen.dart';
import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_event.dart';
import 'package:aisensy/src/core/bloc/home_state.dart';
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: StringConstants.searchPets,
                      labelStyle: TextStyle(
                        color: ColorConstants.grey,
                      ),
                      prefixIcon: Icon(Icons.search, color: ColorConstants.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorConstants.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorConstants.orange),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<HomeBloc>().add(SearchPetsEvent(query: value));
                    },
                  ),
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
                      return _buildPetCard(context, pet);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: state.currentPage > 1
                          ? () {
                              context.read<HomeBloc>().add(ChangePageEvent(page: state.currentPage - 1));
                            }
                          : null,
                    ),
                    Text(
                      '${StringConstants.page} ${state.currentPage}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: state.currentPage * 10 < state.totalPets
                          ? () {
                              context.read<HomeBloc>().add(ChangePageEvent(page: state.currentPage + 1));
                            }
                          : null,
                    ),
                  ],
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

  Widget _buildPetCard(BuildContext context, PetModel pet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: context.read<HomeBloc>(),
              child: DetailsScreen(
                pet: pet,
                onAdopt: () {
                  context.read<HomeBloc>().add(AdoptPetEvent(petId: pet.id));
                  _showAdoptionPopup(newContext, pet.name);
                },
              ),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  pet.image,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${StringConstants.age}: ${pet.age} ${StringConstants.years}',
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              Text(
                '${StringConstants.price}: \$${pet.price}',
                style: TextStyle(
                  color: Colors.orangeAccent.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (!pet.adopted) {
                      context.read<HomeBloc>().add(AdoptPetEvent(petId: pet.id));
                      _showAdoptionPopup(context, pet.name);
                    }
                  },
                  child: Text(
                    pet.adopted ? StringConstants.adopted : StringConstants.adopt,
                    style: TextStyle(
                      color: pet.adopted ? Colors.green : Colors.blue, // Adopted: green, Adopt: blue
                      fontWeight: FontWeight.bold,
                      decoration: pet.adopted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdoptionPopup(BuildContext context, String petName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adopted!'),
        content: Text("You have adopted $petName."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
