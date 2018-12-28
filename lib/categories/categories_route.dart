import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unit_converter_flutter_app/categories/categories.dart';
import 'package:unit_converter_flutter_app/common/widgets/category_tile.dart';
import 'package:unit_converter_flutter_app/common/widgets/backdrop.dart';
import 'package:unit_converter_flutter_app/common/api/api.dart';
import 'package:unit_converter_flutter_app/common/api/category.dart';
import 'package:unit_converter_flutter_app/common/widgets/custom_loading.dart';
import 'package:unit_converter_flutter_app/unit_converter/unit_converter.dart';

class CategoriesRoute extends StatefulWidget {
  CategoriesBloc categoriesBloc;

  CategoriesRoute({
    @required this.categoriesBloc,
  }) : assert(categoriesBloc != null);

  @override
  _CategoriesRouteState createState() => _CategoriesRouteState();
}

class _CategoriesRouteState extends State<CategoriesRoute> {
  UnitConverterBloc _unitConverterBloc;

  Widget _buildBody() {
    return BlocBuilder<CategoriesEvent, CategoriesState>(
      bloc: widget.categoriesBloc,
      builder: (BuildContext context, CategoriesState categoriesState) {
        if (categoriesState.isLoading) {
          return CustomLoading();
        }

        if (categoriesState.categories.isEmpty) {
          return Center(
            child: Container(
              height: 180.0,
              width: 180.0,
              child: Text('no data!!!'),
            ),
          );
        }

        assert(debugCheckHasMediaQuery(context));
        final listView = Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 48.0,
          ),
          child: _buildCategoryWidgets(
              categoriesState.categories, MediaQuery.of(context).orientation),
        );

        if (_unitConverterBloc == null ||
            categoriesState.currentCategory != _unitConverterBloc.category) {
          _unitConverterBloc =
              UnitConverterBloc(category: categoriesState.currentCategory);
          _unitConverterBloc.dispatch(FetchUnitsUnitConverterEvent());
        }

        return Backdrop(
          currentCategory: categoriesState.currentCategory,
          frontPanel: UnitConverterWidget(
            bloc: _unitConverterBloc,
          ),
          backPanel: listView,
          frontTitle: Text('Unit Converter'),
          backTitle: Text('Select a Category'),
        );
      },
    );
  }

  Widget _buildCategoryWidgets(
      List<Category> categories, Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _category = categories[index];
          return CategoryTile(
            category: _category,
            onTap: _category.fromApi == true && _category.units.isEmpty
                ? null
                : _onCategoryTap,
          );
        },
        itemCount: categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  void _onCategoryTap(Category category) {
    widget.categoriesBloc
        .dispatch(SelectCategoryCategoriesEvent(selectedCategory: category));
  }

  @override
  void initState() {
    super.initState();

    widget.categoriesBloc.dispatch(FetchCategoriesEvent());
  }

  @override
  void dispose() {
    _unitConverterBloc.dispose();
    widget.categoriesBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
