import 'package:unit_converter_flutter_app/common/api/category.dart';

class CategoriesState {
  final String error;
  final bool isLoading;
  final Category currentCategory;
  final List<Category> categories;

  CategoriesState({
    this.isLoading,
    this.categories,
    this.currentCategory,
    this.error,
  });

  factory CategoriesState.initial() {
    return CategoriesState(
      isLoading: false,
      categories: const [],
      currentCategory: null,
    );
  }

  factory CategoriesState.loading() {
    return CategoriesState(
      isLoading: true,
      categories: const [],
      currentCategory: null,
    );
  }

  factory CategoriesState.loaded(
      List<Category> categories, Category currentCategory) {
    return CategoriesState(
      isLoading: false,
      categories: categories,
      currentCategory: currentCategory,
    );
  }

  factory CategoriesState.failure(String error) {
    return CategoriesState(
      isLoading: false,
      error: error,
    );
  }

  @override
  String toString() => 'CategoriesState { '
      ' isLoading: $isLoading,'
      '}';
}
