import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_event.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:aisensy/src/features/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    super.key,
    required this.pet,
  });

  final PetModel pet;

  @override
  Widget build(BuildContext context) {
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
