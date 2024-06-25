// ignore: library_prefixes
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/modals/todo_item_edit.dart';
import 'package:flutter_application_1/todo_item.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoItemListView extends StatelessWidget {
  final List<TodoItem> todoItems;
  final List<TodoItem> todoList;
  final Function() refresh;
  const TodoItemListView(
      {super.key,
      required this.todoItems,
      required this.todoList,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todoList.length,
      itemBuilder: (_, index) {
        TodoItem todoItem = todoList[index];
        String amountText = "";

        if (todoItem.amount > 0) {
          amountText += todoItem.amount.toString();
          if (todoItem.amountUnit != null) {
            amountText += " ${todoItem.amountUnit}";
          }
        }

        todoItem.categories.sort((a, b) => a.id.compareTo(b.id));

        return Card(
          key: Key("$index${todoItem.title}"),
          child: Slidable(
            key: Key("$index"),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    todoItems.remove(todoItem);
                    refresh();
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '削除',
                ),
              ],
            ),
            child: ListTile(
              key: Key("$index"),
              title: Text(
                todoItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: todoItem.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: amountText == ""
                  ? null
                  : Text(
                      amountText,
                      style: const TextStyle(fontSize: 12),
                    ),
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (context) {
                      return TodoEditModal(
                        todoItem: todoItem,
                      );
                    }).then((value) => {
                      if (value != null) {updateItem(value)}
                    });
              },
              leading: Checkbox(
                value: todoItem.isCompleted,
                onChanged: (_) {
                  todoItem.isCompleted = !todoItem.isCompleted;
                  refresh();
                },
              ),
            ),
          ),
        );
      },
      onReorder: ((oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        newIndex = Math.max(newIndex, 0);
        final int moveToIndex = todoList[newIndex].index;
        final TodoItem moveItem = todoItems.removeAt(todoList[oldIndex].index);
        todoItems.insert(moveToIndex, moveItem);
        refresh();
      }),
    );
  }

  int boolToInt(value) => value ? 1 : -1;

  updateItem(TodoItem todoItem) {
    todoItems[todoItem.index] = todoItem;
    refresh();
  }
}
