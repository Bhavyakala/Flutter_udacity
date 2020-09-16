import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';


class Category {
  final String categoryName;
  final ColorSwatch color;
  final List<Unit> units;
  final String categoryIcon;
  
  const Category({
    @required this.categoryName,
    @required this.categoryIcon,
    @required this.units, 
    @required this.color,
  }): assert(categoryName!=null),
      assert(color!=null),
      assert(categoryIcon!=null),
      assert(units!=null);
}
  