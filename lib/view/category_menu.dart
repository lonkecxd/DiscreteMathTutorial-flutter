import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:example_flutter/model/data.dart';

class CategoryMenuPage extends StatefulWidget {
  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;

  CategoryMenuPage({
    Key key,
    @required this.currentCategory,
    @required this.onCategoryTap,
  })  : assert(currentCategory != null),
        assert(onCategoryTap != null);

  @override
  _CategoryMenuPageState createState() => _CategoryMenuPageState();
}

class _CategoryMenuPageState extends State<CategoryMenuPage> {
  final List<Category> _categories = DummyDataService.getCategories();

  bool openSubCate = false;

  _onTapFather(){
    setState(() {
      openSubCate = true;
    });
  }

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString = category.name.toUpperCase();
    List<String> subCategories = category.children.map((e) => e.name).toList();
    final ThemeData theme = Theme.of(context);
    final bool inTheCate = category.children.map((e) => e.name).toList().contains(widget.currentCategory.name);

    return GestureDetector(
      onTap: () => widget.onCategoryTap(category),
      child: widget.currentCategory.name == category.name
          ? Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          Text(
            categoryString,
            style: theme.textTheme.bodyText2.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.0),
          Container(
            height: 2,
            width: 80,
            color: Colors.black54,
          ),
          GestureDetector(
            onTap: () => widget.onCategoryTap(category),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  children: subCategories.map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e,style: TextStyle(fontSize: 14,color: Colors.black45),),
                  )).toList(),
              ),
            ),
          ),

        ],
      )
          : Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          categoryString,
          style: theme.textTheme.bodyText2.copyWith(
              color: Colors.black54.withAlpha(153)
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        decoration: BoxDecoration(gradient: LinearGradient(colors:[Colors.greenAccent, Colors.lightBlueAccent])),
        child: ListView(
            children: _categories
                .map((Category c) => _buildCategory(c, context))
                .toList()),
      ),
    );
  }
}