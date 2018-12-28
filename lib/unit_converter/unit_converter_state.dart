import 'package:meta/meta.dart';
import 'package:unit_converter_flutter_app/common/api/unit.dart';

class UnitConverterState {
  final String error;
  final bool isLoading;
  final List<Unit> units;
  final Unit fromUnit;
  final Unit toUnit;
  final String convertedValue;
  final String inputValue;

  const UnitConverterState({
    this.error,
    @required this.isLoading,
    @required this.units,
    this.fromUnit,
    this.toUnit,
    this.convertedValue,
    this.inputValue,
  });

  factory UnitConverterState.initial() {
    return UnitConverterState(
      isLoading: false,
      units: [],
      error: null,
      inputValue: null,
    );
  }

  factory UnitConverterState.loading(UnitConverterState state) {
    return UnitConverterState(
      isLoading: true,
      units: state.units,
      fromUnit: state.fromUnit,
      toUnit: state.toUnit,
      convertedValue: state.convertedValue,
      error: null,
      inputValue: state.inputValue,
    );
  }

  factory UnitConverterState.loaded(
      {List<Unit> units,
      Unit fromUnit,
      Unit toUnit,
      String convertedValue,
      String validationError,
      String inputValue}) {
    return UnitConverterState(
      isLoading: false,
      units: units,
      fromUnit: fromUnit,
      toUnit: toUnit,
      convertedValue: convertedValue,
      error: null,
      inputValue: inputValue,
    );
  }

  factory UnitConverterState.failure(
      UnitConverterState state, String errorMessage) {
    return UnitConverterState(
      isLoading: false,
      units: state.units,
      error: errorMessage,
      fromUnit: state.fromUnit,
      toUnit: state.toUnit,
      convertedValue: null,
      inputValue: state.inputValue,
    );
  }

  @override
  String toString() => 'UnitConverterState { '
      ' isLoading: $isLoading,'
      '}';
}
