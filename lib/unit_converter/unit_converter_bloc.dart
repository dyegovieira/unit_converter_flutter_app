import 'dart:async';

import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';

import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

import 'package:unit_converter_flutter_app/common/api/api.dart';
import 'package:unit_converter_flutter_app/common/api/category.dart';
import 'package:unit_converter_flutter_app/common/api/unit.dart';
import 'package:unit_converter_flutter_app/unit_converter/unit_converter_event.dart';
import 'package:unit_converter_flutter_app/unit_converter/unit_converter_state.dart';

class UnitConverterBloc extends Bloc<UnitConverterEvent, UnitConverterState> {
  final Category category;

  UnitConverterBloc({
    @required this.category,
  });

  @override
  UnitConverterState get initialState => UnitConverterState.initial();

  @override
  Stream<UnitConverterState> mapEventToState(
      UnitConverterState state, UnitConverterEvent event) async* {
    if (event is FetchUnitsUnitConverterEvent) {
      yield UnitConverterState.loading(state);

      yield UnitConverterState.loaded(
        units: category.units,
        fromUnit: category.units[0],
        toUnit: category.units[1],
        convertedValue: null,
        validationError: null,
      );
    }

    if (event is SelectFromUnitConverterEvent) {
      yield UnitConverterState.loading(state);

      Unit unit = _getUnit(event.unitName);

      try {
        String convertedValue =
            await _updateInputValue(state.inputValue, unit, state.toUnit);

        yield UnitConverterState.loaded(
          units: category.units,
          fromUnit: unit,
          toUnit: state.toUnit,
          convertedValue: convertedValue,
          validationError: null,
          inputValue: state.inputValue,
        );
      } catch (e) {
        yield UnitConverterState.failure(state, e);
      }
    }

    if (event is SelectToUnitConverterEvent) {
      yield UnitConverterState.loading(state);

      Unit unit = _getUnit(event.unitName);

      try {
        String convertedValue =
            await _updateInputValue(state.inputValue, state.fromUnit, unit);

        yield UnitConverterState.loaded(
          units: category.units,
          fromUnit: state.fromUnit,
          toUnit: unit,
          convertedValue: convertedValue,
          validationError: null,
          inputValue: state.inputValue,
        );
      } catch (e) {
        yield UnitConverterState.failure(state, e);
      }
    }

    if (event is OnChangeInputUnitConverterEvent) {
      yield UnitConverterState.loading(state);

      try {
        String convertedValue = await _updateInputValue(
            event.inputValue, state.fromUnit, state.toUnit);

        yield UnitConverterState.loaded(
          units: category.units,
          fromUnit: state.fromUnit,
          toUnit: state.toUnit,
          convertedValue: convertedValue,
          validationError: null,
          inputValue: event.inputValue,
        );
      } catch (e) {
        yield UnitConverterState.failure(state, e);
      }
    }
  }

  // Methods

  Unit _getUnit(String unitName) {
    return category.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  Future<String> _updateInputValue(
      String input, Unit fromUnit, Unit toUnit) async {
    if (input == null || input.isEmpty) {
      return null;
    } else {
      // Even though we are using the numerical keyboard, we still have to check
      // for non-numerical input such as '5..0' or '6 -3'
      try {
        final inputDouble = double.parse(input);
        return await _updateConversion(inputDouble, fromUnit, toUnit);
      } on Exception catch (e) {
        throw ('Invalid number entered');
      }
    }
  }

//
  Future<String> _updateConversion(
      double inputValue, Unit fromUnit, Unit toUnit) async {
    if (category.fromApi == true) {
      try {
        final api = Api();
        final conversion = await api.convert(apiCategory['route'],
            inputValue.toString(), fromUnit.name, toUnit.name);

        if (conversion == null) {
          throw ("Oh no! We can't connect right now!");
        } else {
          return _format(conversion);
        }
      } catch (e) {
        throw (e);
      }
    } else {
      // For the static units, we do the conversion ourselves
      return _format(inputValue * (toUnit.conversion / fromUnit.conversion));
    }
  }

  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }
}
