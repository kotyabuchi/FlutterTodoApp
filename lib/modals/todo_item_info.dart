import 'package:flutter/material.dart';
import 'package:flutter_application_1/category.dart';
import 'package:flutter_application_1/modals/todo_item_edit.dart';
import 'package:flutter_application_1/todo_item.dart';

class TodoInfoModal extends StatefulWidget {
  final TodoItem todoItem;
  final List<TodoItem> todoItems;
  final Function() refresh;

  const TodoInfoModal({
    super.key,
    required this.todoItem,
    required this.todoItems,
    required this.refresh,
  });

  @override
  State<TodoInfoModal> createState() => _TodoInfoModalState();
}

class _TodoInfoModalState extends State<TodoInfoModal> {
  final formPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 20);
  late TodoItem todoItem;

  @override
  void initState() {
    super.initState();
    setState(() {
      todoItem = widget.todoItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 60),
              Text(
                todoItem.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                width: 60,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          useSafeArea: true,
                          builder: (context) {
                            return TodoEditModal(todoItem: todoItem);
                          }).then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  todoItem = value;
                                  widget.todoItems[todoItem.index] = value;
                                  widget.refresh();
                                })
                              }
                          });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: formPadding,
            child: Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  "個数",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(todoItem.amount.toString()),
                Text(todoItem.amountUnit ?? ""),
              ],
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: formPadding,
            child: Row(
              children: [
                Icon(
                  Icons.sell,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                if (todoItem.categories.isEmpty) ...{
                  Text(
                    "カテゴリー",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                } else ...{
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      for (Category category in todoItem.categories) ...{
                        Container(
                          decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(category.title),
                          ),
                        ),
                        const SizedBox(width: 8),
                      },
                    ],
                  ),
                },
              ],
            ),
          ),
          const Divider(height: 0),
          const SizedBox(height: 60)
        ],
      ),
    );
  }
}
