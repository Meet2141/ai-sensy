import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_state.dart';
import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final PetModel pet;
  final VoidCallback onAdopt;

  const DetailsScreen({
    super.key,
    required this.pet,
    required this.onAdopt,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2), // Increased duration
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PetModel updatedPet = widget.pet;

    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadedState && state.displayedPets.contains(updatedPet)) {
            if (updatedPet.adopted) {
              _confettiController.play();
            }
          }
        },
        builder: (context, state) {
          if (state is HomeLoadedState) {
            updatedPet = state.displayedPets.firstWhere(
              (p) => p.id == widget.pet.id,
              orElse: () => widget.pet,
            );
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple.shade100, Colors.orange.shade100],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.all(16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => InteractiveViewer(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/placeholder.png',
                                          // Add a placeholder image
                                          image: updatedPet.image,
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/placeholder.png',
                                      image: updatedPet.image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${StringConstants.name}: ${updatedPet.name}',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${StringConstants.age}: ${updatedPet.age} ${StringConstants.years}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${StringConstants.price}: \$${updatedPet.price}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                updatedPet.adopted
                                    ? Text(
                                        StringConstants.alreadyAdopt,
                                        style: TextStyle(color: ColorConstants.grey),
                                      )
                                    : ElevatedButton(
                                        onPressed: widget.onAdopt,
                                        child: Text(StringConstants.adoptMe),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                gravity: 0.3,
                numberOfParticles: 150,
                maxBlastForce: 50,
                minBlastForce: 25,
                emissionFrequency: 0.05,
                blastDirection: 3.14,
              ),
            ],
          );
        },
      ),
    );
  }
}
