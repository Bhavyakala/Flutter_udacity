import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'unit.dart';
import 'category.dart';

const _padding  = EdgeInsets.all(16.0);

class UnitConverter extends StatefulWidget {
  final Category category;

  const UnitConverter({
    @required this.category
  }) : assert(category!=null);

  @override
  _UnitConverter createState() => _UnitConverter();
}

class _UnitConverter extends State<UnitConverter> {

  // ignore: todo
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  double _inputValue;
  String _convertedValue = '';
  Unit _fromUnit;
  Unit _toUnit;
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;
  final _inputKey = GlobalKey(debugLabel: 'inputText');

  // ignore: todo
  // TODO: Determine whether you need to override anything, such as initState()
  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

 @override
  void didUpdateWidget(UnitConverter old) {
    super.didUpdateWidget(old);
    // We update our [DropdownMenuItem] units when we switch [Categories].
    if (old.category != widget.category) {
      _createDropdownMenuItems();
      _setDefaults();
    }
  }

  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for(var unit in widget.category.units) {
      newItems.add(
        new DropdownMenuItem(
          value:  unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            )
          ),
        )
      );
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _fromUnit = widget.category.units[0];
      _toUnit = widget.category.units[1];
    });
  }
  // ignore: todo
  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
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

  void _updateConversion() {
    setState(() {
      _convertedValue = _format(_inputValue * (_toUnit.conversion / _fromUnit.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if(input==null || input.isEmpty) {
        _convertedValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit _getUnit(String unitName) {
    return widget.category.units.firstWhere((Unit unit) {
      return unit.name==unitName;
    }, orElse: null, );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromUnit = _getUnit(unitName);
    });
    if(_inputValue!=null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toUnit = _getUnit(unitName);
    });
    if(_inputValue!=null) {
      _updateConversion();
    }
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged)  {
    return Container( 
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.grey[100],
          width: 1.0,
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.grey[100]),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.title,
            ),
          ) 
        ),
      ),
    );
  }
   
  @override
  Widget build(BuildContext context) {

    final inputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(
              labelText: 'Input',
              labelStyle: Theme.of(context).textTheme.headline4,
              errorText: _showValidationError? 'Invalid number entered': null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              )
            ),
            onChanged:  _updateInputValue, 
          ),
          _createDropdown(_fromUnit.name, _updateFromConversion),
        ],
      ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final outputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _convertedValue,
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'output',
              // ignore: deprecated_member_use
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0)
              ),
            ),
          ),
          _createDropdown(_toUnit.name, _updateToConversion),
        ],
      )
    );   

    final converter = ListView(
      children: [
        inputWidget,
        arrows,
        outputWidget,
      ],
    );
    return Padding(
      padding: _padding, 
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if(orientation==Orientation.portrait) {
            return converter;
          } else {
            return Center(
              child:  Container(
                width: 450.0,
                child: converter,
              ),
            );
          }
        },
      ),
    );
  }
}