import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:unit_converter_flutter_app/categories/categories_event.dart';
import 'package:unit_converter_flutter_app/categories/categories_state.dart';
import 'package:unit_converter_flutter_app/common/api/api.dart';
import 'package:unit_converter_flutter_app/common/api/category.dart';
import 'package:unit_converter_flutter_app/common/api/unit.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final BuildContext context;

  CategoriesBloc({
    @required this.context,
  });

  CategoriesState get initialState => CategoriesState.initial();

  @override
  Stream<CategoriesState> mapEventToState(
      CategoriesState state, CategoriesEvent event) async* {
    if (event is FetchCategoriesEvent) {
      yield CategoriesState.loading();

      try {
        List<Category> categories = [];

        categories = await _retrieveApiCategory();
        categories = await _retrieveLocalCategories(context, categories);

        yield CategoriesState.loaded(categories, categories.first);
      } catch (error) {
        yield CategoriesState.failure(error.toString());
      }
    }

    if (event is SelectCategoryCategoriesEvent) {
      yield CategoriesState.loaded(state.categories, event.selectedCategory);
    }
  }

  // Methods

  Future<List<Category>> _retrieveLocalCategories(
      BuildContext context, List<Category> categories) async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    var categoryIndex = 0;
    List<Category> _categories = categories ?? [];

    data.keys.forEach((key) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        iconLocation: _icons[categoryIndex],
        fromApi: false,
      );

      _categories.add(category);
      categoryIndex += 1;
    });

    return _categories;
  }

  Future<List<Category>> _retrieveApiCategory() async {
    List<Category> categories = [];

    categories.add(Category(
      name: apiCategory['name'],
      units: [],
      color: _baseColors.last,
      iconLocation: _icons.last,
      fromApi: false,
    ));

    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);

    if (jsonUnits != null) {
      final units = <Unit>[];

      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }

      categories.removeLast();
      categories.add(Category(
        name: apiCategory['name'],
        units: units,
        color: _baseColors.last,
        iconLocation: _icons.last,
        fromApi: true,
      ));
    }

    return categories;
  }
}

final _baseColors = <ColorSwatch>[
  ColorSwatch(0xFF6AB7A8, {
    'highlight': Color(0xFF6AB7A8),
    'splash': Color(0xFF0ABC9B),
  }),
  ColorSwatch(0xFFFFD28E, {
    'highlight': Color(0xFFFFD28E),
    'splash': Color(0xFFFFA41C),
  }),
  ColorSwatch(0xFFFFB7DE, {
    'highlight': Color(0xFFFFB7DE),
    'splash': Color(0xFFF94CBF),
  }),
  ColorSwatch(0xFF8899A8, {
    'highlight': Color(0xFF8899A8),
    'splash': Color(0xFFA9CAE8),
  }),
  ColorSwatch(0xFFEAD37E, {
    'highlight': Color(0xFFEAD37E),
    'splash': Color(0xFFFFE070),
  }),
  ColorSwatch(0xFF81A56F, {
    'highlight': Color(0xFF81A56F),
    'splash': Color(0xFF7CC159),
  }),
  ColorSwatch(0xFFD7C0E2, {
    'highlight': Color(0xFFD7C0E2),
    'splash': Color(0xFFCA90E5),
  }),
  ColorSwatch(0xFFCE9A9A, {
    'highlight': Color(0xFFCE9A9A),
    'splash': Color(0xFFF94D56),
    'error': Color(0xFF912D2D),
  }),
];

final _icons = <String>[
  'assets/icons/length.png',
  'assets/icons/area.png',
  'assets/icons/volume.png',
  'assets/icons/mass.png',
  'assets/icons/time.png',
  'assets/icons/digital_storage.png',
  'assets/icons/power.png',
  'assets/icons/currency.png',
];
