import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modals/todo_item_edit.dart';
import 'package:flutter_application_1/todo_item.dart';
import 'package:flutter_application_1/widgets/item_list_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> todoItems = TodoItem.getDummy();

  bool onSearch = false;
  String filterText = "";

  bool isSepareteCompleted = true;

  @override
  Widget build(BuildContext context) {
    todoItems.asMap().forEach((index, item) {
      item.index = index;
    });
    todoItems.sort((a, b) {
      int result = a.index.compareTo(b.index);
      if (result != 0) return result;
      return a.createAt.compareTo(b.createAt);
    });

    List<TodoItem> filteredItems = todoItems;

    if (filterText != "") {
      filterText = hiraganaToKatakana(filterText);
      filteredItems = todoItems
          .where((element) => RegExp(filterText, caseSensitive: false).hasMatch(
              hiraganaToKatakana(
                  "${element.title} ${element.categories.map((e) => e.title).join(" ")}")))
          .toList();
    }

    List<TodoItem> notCompleteItems =
        filteredItems.where((element) => !element.isCompleted).toList();
    List<TodoItem> completedItems =
        filteredItems.where((element) => element.isCompleted).toList();

    final focusNode = FocusNode();

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: onSearch
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      autofocus: true,
                      decoration:
                          const InputDecoration(hintText: "キーワードを入力して検索"),
                      onChanged: (value) {
                        setState(() {
                          filterText = value.trim();
                        });
                      },
                    ),
                  )
                : Text(widget.title),
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            actions: onSearch
                ? [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            onSearch = false;
                            filterText = "";
                          });
                        },
                        icon: const Icon(Icons.clear)),
                  ]
                : [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            onSearch = true;
                          });
                        },
                        icon: const Icon(Icons.search)),
                  ],
          ),
          body: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isSepareteCompleted,
                        onChanged: (value) {
                          setState(() {
                            isSepareteCompleted = value ?? true;
                          });
                        },
                      ),
                      GestureDetector(
                        child: const Text("完了済を分ける"),
                        onTap: () {
                          setState(() {
                            isSepareteCompleted = !isSepareteCompleted;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: isSepareteCompleted
                        ? [
                            TodoItemListView(
                              todoItems: todoItems,
                              todoList: notCompleteItems,
                              refresh: () => {setState(() {})},
                            ),
                            const ListTile(
                              title: Text("完了済!!!"),
                            ),
                            TodoItemListView(
                              todoItems: todoItems,
                              todoList: completedItems,
                              refresh: () => {setState(() {})},
                            ),
                          ]
                        : [
                            TodoItemListView(
                              key: const Key("SingleListView"),
                              todoItems: todoItems,
                              todoList: todoItems,
                              refresh: () => {setState(() {})},
                            ),
                          ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  useSafeArea: true,
                  builder: (context) {
                    return const TodoEditModal();
                  }).then((value) => {
                    if (value != null)
                      {
                        setState(() {
                          todoItems.add(value);
                        })
                      }
                  });
            },
            tooltip: 'AddItem',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
