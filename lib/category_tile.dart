import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'category.dart';
import 'unit_converter.dart';


const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class CategoryTile extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onTap;

  const CategoryTile({
    Key key,
    @required this.category,
    @required this.onTap
  }): assert(category!=null),
      assert(onTap!=null),
      super(key: key);


  void _navigateToConverter(BuildContext context) {
    // ignore: todo
    // TODO: Using the Navigator, navigate to the [ConverterRoute]
    Navigator.of(context).push( 
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(

            appBar: AppBar(
              elevation: 1.0,
              title: Text(
                this.category.categoryName,
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.display1,
              ),
              centerTitle: true,
              backgroundColor: category.color,
            ),

            body: UnitConverter(
              category: category,
            )

          );
        },
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    return Material(
      color: Colors.transparent,

      child: Container(
        height: _rowHeight,
        padding: EdgeInsets.all(8.0),

        child : InkWell(
          splashColor: this.category.color['splash'],
          highlightColor: this.category.color['highlight'],
          borderRadius: _borderRadius,
          onTap: () { 
            print('tapped'); 
            onTap(category);
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row ( 
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),   
                  child: Icon(
                    this.category.categoryIcon, 
                    size: 60.0
                  ),
                ),

                Center(
                  child: Text(
                    this.category.categoryName,
                    style: Theme.of(context).textTheme.headline5, 
                    textAlign: TextAlign.center
                  )
                ),
              ],
            )
          )
        )
      )
    );
  }
}