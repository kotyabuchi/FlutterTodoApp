import 'dart:math';

import 'package:flutter_application_1/category.dart';

class TodoItem {
  String title;
  DateTime createAt;
  bool isCompleted;
  int index;
  int amount;
  String? amountUnit;
  List<Category> categories = [];

  TodoItem({
    required this.title,
    required this.createAt,
    this.isCompleted = false,
    this.index = 0x7FFFFFFFFFFFFFFF,
    this.amount = 0,
    this.amountUnit,
    this.categories = const [],
  });

  static List<TodoItem> getDummy() {
    List<Category> categoriesDummy = Category.getDummy();
    List<String> dummyData = [
      "明日葉",
      "アスパラガス",
      "ウコン",
      "枝豆",
      "大葉・しそ",
      "オクラ",
      "カブ（かぶ）",
      "かぼちゃ",
      "カリフラワー",
      "キャベツ",
      "きゅうり",
      "空心菜（くうしんさい）",
      "クレソン",
      "ごぼう",
      "ごま",
      "小松菜",
      "ゴーヤ（苦瓜）",
      "こんにゃく",
      "さつまいも",
      "里芋（さといも）",
      "さやいんげん",
      "さやえんどう（きぬさや）",
      "ししとうがらし（ししとう）",
      "しそ・大葉",
      "じゃがいも",
      "春菊（菊菜）",
      "ズッキーニ",
      "セロリ",
      "そら豆",
      "ターサイ（タアサイ）",
      "大根（だいこん）",
      "高菜（たかな）",
      "玉ねぎ",
      "たけのこ",
      "チンゲン菜（青梗菜）",
      "つるむらさき",
      "唐辛子（とうがらし）",
      "冬瓜（とうがん）",
      "とうみょう",
      "とうもろこし",
      "トマト"
    ];
    List<TodoItem> result = [];
    for (var dummy in dummyData) {
      List<Category> categories = categoriesDummy.sublist(
          0, Random().nextInt(categoriesDummy.length + 1));
      result.add(TodoItem(
        title: dummy,
        createAt: DateTime.now(),
        amount: Random().nextInt(10),
        categories: categories,
      ));
    }

    return result;
  }

  @override
  String toString() {
    return {
      "title": title,
      "createAt": createAt,
      "isCompleted": isCompleted,
      "index": index,
      "amount": amount,
      "amountUnit": amountUnit,
      "categories": [
        for (Category category in categories) ...{
          {
            "id": category.id,
            "title": category.title,
            "color": category.color.toString(),
          }
        }
      ]
    }.toString();
  }
}
