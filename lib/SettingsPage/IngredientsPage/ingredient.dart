import 'package:flutter/material.dart';

/// The [Ingredient] class describes an ice cream ingredient.
/// It is not a widget.
///
/// Qualitative data
/// name: ingredient name
///
/// Quantitative data
/// ingredient_id: ingredient ID (not named using lowerCamelCase bc of MySQL constraints)

class Ingredient {
  String name;
  String ingredient_id;

  Ingredient({
    @required this.name,
    @required this.ingredient_id,
  });
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      ingredient_id: json['ingredient_id'],
    );
  }
}
