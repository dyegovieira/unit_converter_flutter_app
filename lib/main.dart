import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:unit_converter_flutter_app/categories/categories.dart';

class AppBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    //print(transition.toString());
  }
}

void main() {
  BlocSupervisor().delegate = AppBlocDelegate();
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatefulWidget {
  @override
  _UnitConverterAppState createState() => _UnitConverterAppState();
}

class _UnitConverterAppState extends State<UnitConverterApp> {
  CategoriesBloc _categoriesBloc;

  @override
  Widget build(BuildContext context) {
    if (_categoriesBloc == null) {
      _categoriesBloc = CategoriesBloc(context: context);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: CategoriesRoute(categoriesBloc: _categoriesBloc),
    );
  }

  @override
  void dispose() {
    _categoriesBloc.dispose();

    super.dispose();
  }
}
