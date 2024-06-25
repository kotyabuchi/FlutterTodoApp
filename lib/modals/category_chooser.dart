import 'package:flutter/material.dart';
import 'package:flutter_application_1/category.dart';
import 'package:flutter_application_1/main.dart';

class CategoryChooser extends StatefulWidget {
  final List<Category> itemCategories;
  const CategoryChooser({super.key, required this.itemCategories});

  @override
  State<CategoryChooser> createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  late final List<Category> categories;
  Category? selectedCategory;
  late String filterText;
  bool dragging = false;
  final ScrollController _scrollController = ScrollController();
  List<Category> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    categories = Category.getDummy();
    filterText = "";

    _scrollController.addListener(() {
      ScrollPosition position = _scrollController.position;
      double pixelPerItem =
          position.maxScrollExtent / filteredCategories.length;
      double nowPosition = position.pixels;
      double nowItem = nowPosition / pixelPerItem;

      // print("$nowPosition, ${position.maxScrollExtent}");

      // if (0 < nowPosition && nowPosition < position.maxScrollExtent) {
      //   _scrollController.jumpTo(nowItem.roundToDouble() * pixelPerItem);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    filteredCategories = categories;

    if (filterText.isNotEmpty) {
      filterText = hiraganaToKatakana(filterText);
      filteredCategories = categories
          .where((element) => RegExp(filterText, caseSensitive: false)
              .hasMatch(hiraganaToKatakana(element.title)))
          .toList();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8, bottom: 20, left: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, selectedCategory);
                  },
                  child: const Text("追加"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20, left: 20),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "キーワードを入力して検索"),
                  onChanged: (value) {
                    setState(() {
                      filterText = value.trim();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 24,
                  diameterRatio: 1.5,
                  useMagnifier: true,
                  magnification: 1.5,
                  overAndUnderCenterOpacity: .8,
                  controller: _scrollController,
                  children: filteredCategories.map(
                    (category) {
                      return Text(
                        category.title,
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ).toList(),
                  onSelectedItemChanged: (value) {
                    selectedCategory = categories[value];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
