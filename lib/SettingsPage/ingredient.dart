import 'package:flutter/material.dart';

/// The [Ingredient] class describes an ice cream ingredient.
/// It is not a widget.
///
/// Qualitative data
/// name: ingredient name
///
/// Quantitative data
/// id: ingredient ID

class Ingredient {
  String name;
  int id;

  Ingredient({
    @required this.name,
    this.id,
  });
}
