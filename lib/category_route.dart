import 'package:flutter/material.dart';
import 'package:hello_rectangle/category_tile.dart';
import 'package:hello_rectangle/unit_converter.dart';
import 'category.dart';
import 'unit.dart';
import 'backdrop.dart';
import 'dart:convert';
import 'dart:async';

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();
  
  @override
  _CategoryRouteState createState() => _CategoryRouteState();

}

class _CategoryRouteState extends State<CategoryRoute> {

  final _categories  = <Category>[];
  Category _currentCategory; 
  Category _defaultCategory;
  
  // static const _categoryNames = <String>[
  //   'Length',
  //   'Area',
  //   'Volume',
  //   'Mass',
  //   'Time',
  //   'Digital Storage',
  //   'Energy',
  //   'Currency',
  // ];

  static const _baseColors = <ColorSwatch>[
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

  // @override 
  // @mustCallSuper
  // void initState() {
  //   super.initState();
  //   for(var i=0; i<_categoryNames.length; i++) {
  //     var category = (Category(
  //       categoryName: _categoryNames[i],
  //       color: _baseColors[i],
  //       categoryIcon: Icons.cake,
  //       units: _retrieveUnitList(_categoryNames[i]),
  //     ));
  //     if(i==0) {
  //       _defaultCategory = category;
  //     }
  //     _categories.add(category);
  //   }
  // } 

  // TODO: Uncomment this out. We use didChangeDependencies() so that we can
  // wait for our JSON asset to be loaded in (async).
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json  = DefaultAssetBundle
                  .of(context)
                  .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if(data is! Map) {
      throw ("Data retrieved from API is not a Map");
    }
    var categoryIndex = 0;
    for(var key in data.keys) {
      // print(key);
      final List<Unit> units = data[key].map<Unit>((dynamic data)=> Unit.fromJson(data)).toList();
      // print(units);
      var category  = Category(
        categoryName: key, 
        categoryIcon: Icons.cake, 
        units: units,
        color: _baseColors[categoryIndex],
      );
      setState(() {
        if(categoryIndex==0) {
          _defaultCategory = category;
        } 
        _categories.add(category);
      });
      categoryIndex+=1;
    } 
  }

  // List<Unit> _retrieveUnitList(String categoryName) {
  //   return List.generate(10, (int i) {
  //     i += 1;
  //     return Unit(
  //       name: '$categoryName Unit $i',
  //       conversion: i.toDouble(),
  //     );
  //   });
  // }
  
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if(deviceOrientation==Orientation.portrait) {
      return ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap
          );
        }
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c, 
            onTap: _onCategoryTap
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    assert(debugCheckHasMediaQuery(context));
    
    final listView  = Container(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation)
    );

    return Backdrop(
      currentCategory: _currentCategory==null? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory==null
      ? UnitConverter(category: _defaultCategory)
      : UnitConverter(category: _currentCategory,),
      backPanel: listView, 
      backTitle: Text('Select a Category'), 
      frontTitle: Text('Unit Converter'),
    );

    // final appBar = AppBar(
    //   elevation: 0.0,
    //   title: Text(
    //     'UNIT CONVERTER',
    //     style: TextStyle(fontSize: 30.0),
    //   ),
    //   centerTitle: true,
    //   backgroundColor: _backgroundColor,
    // );

    // return Scaffold(
    //   appBar: appBar,
    //   body: listView,
    // );
  }
}