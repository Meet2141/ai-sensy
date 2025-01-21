import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_state.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:aisensy/src/features/detail/widgets/detail_card.dart';
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
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
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
                    colors: [
                      Colors.purple.shade100,
                      Colors.orange.shade100,
                    ],
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
                        DetailCard(
                          onAdopt: widget.onAdopt,
                          updatedPet: updatedPet,
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
