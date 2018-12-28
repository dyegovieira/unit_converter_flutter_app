import 'package:meta/meta.dart';

abstract class UnitConverterEvent {}

// Events

class FetchUnitsUnitConverterEvent extends UnitConverterEvent {}

class SelectFromUnitConverterEvent extends UnitConverterEvent {
  final String unitName;

  SelectFromUnitConverterEvent({@required this.unitName});
}

class SelectToUnitConverterEvent extends UnitConverterEvent {
  final String unitName;

  SelectToUnitConverterEvent({@required this.unitName});
}

class OnChangeInputUnitConverterEvent extends UnitConverterEvent {
  final String inputValue;

  OnChangeInputUnitConverterEvent({@required this.inputValue});
}
