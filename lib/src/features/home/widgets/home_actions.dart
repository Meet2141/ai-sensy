import 'package:aisensy/src/core/bloc/home_bloc.dart';
import 'package:aisensy/src/core/bloc/home_event.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({
    super.key,
    required this.currentPage,
    required this.totalPets,
  });

  final int currentPage;
  final int totalPets;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 1
              ? () {
                  context.read<HomeBloc>().add(ChangePageEvent(page: currentPage - 1));
                }
              : null,
        ),
        Text(
          '${StringConstants.page} $currentPage',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage * 10 < totalPets
              ? () {
                  context.read<HomeBloc>().add(ChangePageEvent(page: currentPage + 1));
                }
              : null,
        ),
      ],
    );
  }
}
