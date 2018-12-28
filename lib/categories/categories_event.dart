import 'package:flutter/widgets.dart';

abstract class CategoriesEvent {}

// Events

class FetchCategoriesEvent extends CategoriesEvent {}

class SelectCategoryCategoriesEvent extends CategoriesEvent {
  final selectedCategory;

  SelectCategoryCategoriesEvent({
    this.selectedCategory,
  });
}
