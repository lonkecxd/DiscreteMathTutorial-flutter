// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'dart:ui';

import 'package:example_flutter/model/data.dart';
import 'package:example_flutter/view/AnswerSheetView.dart';
import 'package:example_flutter/view/category_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example_flutter/charts/vertical_bar.dart';
import 'package:example_flutter/view/backdrop.dart';
import 'package:mysql1/mysql1.dart' hide Row;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Category _currentCategory = DummyDataService.Chapter1;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Teaching App',
        theme: CupertinoThemeData(),
        debugShowCheckedModeBanner: false,
        home: Backdrop(
          currentCategory: _currentCategory,
          frontLayer: MyHomePage(
            title: 'Flutter Home Page',
            category: _currentCategory,
          ),
          backLayer: CategoryMenuPage(
            currentCategory: _currentCategory,
            onCategoryTap: _onCategoryTap,
          ),
          //Container(),
          frontTitle: Text('SHRINE'),
          backTitle: Text('MENU'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key key, this.title, this.category: DummyDataService.Chapter1})
      : super(key: key);

  final Category category;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final problemItems = DummyDataService.getProblemDataList();
  final answerItems = DummyDataService.getAnswerSheetDataList(); //可以从本地缓存获得
  List<AnswerSheetsModel> answersheetModels;
  bool beginAnswer = false;
  String name = 'xxx';
  String email = 'xxxxx';

  initState() {
    answersheetModels = getDefaultAnswerSheetModelFromData(answerItems);
    answersheetModels[0].attachToProblemId(problemItems[0].id);
    _getData(1);
  }

  _handleBeginAnswer() {
    setState(() {
      beginAnswer = !beginAnswer;
    });
  }

  _getData(userId) async {
    var settings = new ConnectionSettings(
        host: 'rm-bp12dly90xhy0jbr9fo.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'cxd_1',
        password: 'lonkecxd',
        db: 'student'
    );
    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query('select name, email from users where id = ?', [userId]);
    for (var row in results) {
      print('Name: ${row[0]}, email: ${row[1]}');
      name = row[0];
      email = row[1];
    };

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Text(
                '提示: 你只有一次答题机会。$name',
                style: textTheme.subtitle1.copyWith(color: Colors.teal),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Tooltip(
                  message: '上一题',
                  child: CupertinoButton(
                    child: Icon(
                      Icons.chevron_left,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  //color: Colors.amber,
                  flex: 2,
                  child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [Text('Diagram')]),
                ),
                Expanded(
                  flex: 8,
                  child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '将下列命题符号化：',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                '(1)  吴刚既用功又聪明 \n(2)  吴刚不仅用功而且聪明 \n(3)  张辉与王丽都是三好学生\n(4)  张辉与王丽是同学 \n',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16)),
                          ],
                        )
                      ]),
                ),
                Tooltip(
                  message: '下一题',
                  child: CupertinoButton(
                    child: Icon(Icons.chevron_right, size: 40),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton.filled(
              child: beginAnswer?Text('收起答案'):Text('开始答题'),
              onPressed: _handleBeginAnswer,
            ),
            SizedBox(
              height: 40,
            ),
            beginAnswer?AnswerSheetListView(
              answerSheetModels: answersheetModels,
            ):Container()
          ],
        ),
      ),
    );
  }
}
