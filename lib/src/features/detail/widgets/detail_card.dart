import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:aisensy/src/core/model/home/home_model.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.updatedPet,
    required this.onAdopt,
  });

  final PetModel updatedPet;
  final VoidCallback onAdopt;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    onPressed: onAdopt,
                    child: Text(StringConstants.adoptMe),
                  ),
          ],
        ),
      ),
    );
  }
}
