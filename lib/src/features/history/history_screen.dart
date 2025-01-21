import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<PetModel> adoptedPets;

  const HistoryScreen({super.key, required this.adoptedPets});

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
            title: Row(
              children: [
                Text(
                  StringConstants.adoptionHistory,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: ColorConstants.transparent,
          ),
        ),
      ),
      body: adoptedPets.isEmpty
          ? Center(
              child: Text(
                StringConstants.noAdoptionHistory,
                style: TextStyle(fontSize: 18, color: ColorConstants.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: adoptedPets.length,
              itemBuilder: (context, index) {
                final pet = adoptedPets[index];
                return _buildPetCard(pet);
              },
            ),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                pet.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${StringConstants.adoptionOnAge}: ${pet.age} ${StringConstants.years}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${StringConstants.price}: \$${pet.price}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orangeAccent.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.favorite,
              color: Colors.redAccent,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
