import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Calculates the sum of the primary amounts of a list of [AccountData].
double sumAccountDataPrimaryAmount(List<AccountData> items) =>
    sumOf<AccountData>(items, (item) => item.primaryAmount);

/// Utility function to sum up values in a list.
double sumOf<T>(List<T> list, double getValue(T elt)) {
  double sum = 0;
  for (T elt in list) {
    sum += getValue(elt);
  }
  return sum;
}

/// A data model for an account.
///
/// The [primaryAmount] is the balance of the account in USD.
class AccountData {
  const AccountData({this.name, this.primaryAmount, this.accountNumber});

  /// The display name.
  final String name;

  /// 总分
  final double primaryAmount;

  /// The full displayable account number.
  final String accountNumber;
}

/// A data model for a bill.
class ProblemData {
  ProblemData(
      {this.id, this.description, this.category, this.keywords, this.isSolved});

  final int id;

  final String description;

  final String category;

  final String keywords;

  final bool isSolved;
}

class Category {
  const Category({@required this.name, this.children = null})
      : assert(name != null);

  // A function taking a BuildContext as input and
  // returns the internationalized name of the category.
  final String name;
  final List<Category> children;
}

class AnswerData {
  const AnswerData({this.description, this.isCorrect});

  final String description;
  final bool isCorrect;
}

/// A data model for an alert.
class AlertData {
  AlertData({this.message, this.iconData});

  /// The alert message to display.
  final String message;

  /// The icon to display with the alert.
  final IconData iconData;
}

/// Class to return dummy data lists.
///
/// In a real app, this might be replaced with some asynchronous service.
class DummyDataService {
  static List<ProblemData> getProblemDataList() {
    return <ProblemData>[
      ProblemData(id: 1, description: '将下列命题符号化：', category: '1-5-2'),
      ProblemData(
          id: 2,
          description:
              'In triangle ABC above, AB=AC, E is the midpoint of line AB, and D is the midpoint of line AC. If AE=x and ED=4, what is length BC?',
          category: '2-5-2'),
      ProblemData(
          id: 3,
          description:
              'In the figure above, ABCDEF is a regular hexagon, and its center is point O. What is the value of x?',
          category: '3-5-2'),
    ];
  }

  static const Category Chapter1 =
      Category(name: '第一部分 数理逻辑', children: [
        Category(name: '第一章 命题逻辑的基本概念'),
        Category(name: '第二章 命题逻辑等值演算'),
        Category(name: '第三章 命题逻辑的推理理论'),
        Category(name: '第四章 一阶逻辑基本概念'),
        Category(name: '第五章 一阶逻辑等值演算与推理'),
      ]);
  static Category Chapter2 = Category(
      name: '第二部分 集合论', children: []);
  static Category Chapter3 =
      Category(name: '第三部分 代数结构', children: []);
  static Category Chapter4 =
      Category(name: '第四部分 组合数学', children: []);
  static Category Chapter5 =
  Category(name: '第五部分 图论', children: []);
  static Category Chapter6 =
  Category(name: '第六部分 初等数论', children: []);

  static List<Category> getCategories() {
    return [Chapter1, Chapter2, Chapter3];
  }

  static List<AnswerData> getAnswerSheetDataList() {
    return <AnswerData>[
      AnswerData(description: 'p：吴刚用功', isCorrect: true),
      AnswerData(description: 'q：吴刚聪明', isCorrect: true),
      AnswerData(description: 'r：张辉不是三好生', isCorrect: false),
      AnswerData(description: 's：王丽是三好生', isCorrect: true),
      AnswerData(description: 'p^q', isCorrect: true),
      AnswerData(description: 'p^q', isCorrect: true),
      AnswerData(description: 'q^~p', isCorrect: true),
      AnswerData(description: 'r^s', isCorrect: true),
    ];
  }
}
