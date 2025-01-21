import 'package:aisensy/src/core/constants/color_constants.dart';
import 'package:aisensy/src/core/constants/string_constants.dart';
import 'package:flutter/material.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({
    super.key,
    required this.onSearch,
  });

  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          onSearch.call(value);
        },
      ),
    );
  }
}
