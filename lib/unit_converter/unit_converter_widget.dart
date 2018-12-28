import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unit_converter_flutter_app/common/api/unit.dart';
import 'package:unit_converter_flutter_app/common/widgets/custom_loading.dart';
import 'package:unit_converter_flutter_app/unit_converter/unit_converter.dart';

EdgeInsets _padding = const EdgeInsets.all(16.0);

class UnitConverterWidget extends StatefulWidget {
  UnitConverterBloc bloc;

  UnitConverterWidget({
    @required this.bloc,
  }) : assert(bloc != null);

  @override
  _UnitConverterWidgetState createState() => _UnitConverterWidgetState();
}

class _UnitConverterWidgetState extends State<UnitConverterWidget> {
  final _inputKey = GlobalKey(debugLabel: 'inputText');

  Widget _buildBody() {
    return BlocBuilder<UnitConverterEvent, UnitConverterState>(
      bloc: widget.bloc,
      builder: (BuildContext context, UnitConverterState unitConverterState) {
        Widget _content = Stack(
          children: <Widget>[
            unitConverterState.units.isEmpty
                ? Container()
                : _buildConverter(unitConverterState.units),
            unitConverterState.isLoading ? CustomLoading() : Container(),
          ],
        );

        return Padding(
          padding: _padding,
          child: _content,
        );
      },
    );
  }

  Widget _buildConverter(List<Unit> units) {
    List<DropdownMenuItem> menuItems = [];

    for (var unit in units) {
      menuItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }

    Widget _arrows = RotatedBox(
      quarterTurns:
          MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return ListView(
        children: [
          _buildInput(menuItems),
          _arrows,
          _buildOutput(menuItems),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: _buildInput(menuItems),
            ),
            _arrows,
            Flexible(
              child: _buildOutput(menuItems),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInput(List<DropdownMenuItem> menuItems) {
    return Padding(
      padding: _padding,
      child: BlocBuilder<UnitConverterEvent, UnitConverterState>(
        bloc: widget.bloc,
        builder: (BuildContext context, UnitConverterState unitConverterState) {
          String error = unitConverterState.error;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: _inputKey,
                style: Theme.of(context).textTheme.display1,
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.display1,
                  errorText: error,
                  labelText: 'Input',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => widget.bloc.dispatch(
                    OnChangeInputUnitConverterEvent(inputValue: value)),
              ),
              _buildDropdown(unitConverterState.fromUnit.name, menuItems,
                  _updateFromConversion),
            ],
          );
        },
      ),
    );
  }

  void _updateFromConversion(dynamic unitName) {
    widget.bloc.dispatch(SelectFromUnitConverterEvent(unitName: unitName));
  }

  Widget _buildOutput(List<DropdownMenuItem> menuItems) {
    return Padding(
      padding: _padding,
      child: BlocBuilder<UnitConverterEvent, UnitConverterState>(
        bloc: widget.bloc,
        builder: (BuildContext context, UnitConverterState unitConverterState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputDecorator(
                child: Text(
                  unitConverterState.convertedValue ?? '',
                  style: Theme.of(context).textTheme.display1,
                ),
                decoration: InputDecoration(
                  labelText: 'Output',
                  labelStyle: Theme.of(context).textTheme.display1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              _buildDropdown(unitConverterState.toUnit.name, menuItems,
                  _updateToConversion),
            ],
          );
        },
      ),
    );
  }

  void _updateToConversion(dynamic unitName) {
    widget.bloc.dispatch(SelectToUnitConverterEvent(unitName: unitName));
  }

  Widget _buildDropdown(String currentValue, List<DropdownMenuItem> menuItems,
      ValueChanged<dynamic> onChanged) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: menuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.bloc.dispatch(FetchUnitsUnitConverterEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
