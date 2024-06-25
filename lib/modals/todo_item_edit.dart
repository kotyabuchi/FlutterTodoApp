import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/category.dart';
import 'package:flutter_application_1/modals/category_chooser.dart';
import 'package:flutter_application_1/todo_item.dart';

class TodoEditModal extends StatefulWidget {
  final TodoItem? todoItem;

  const TodoEditModal({super.key, this.todoItem});

  @override
  State<TodoEditModal> createState() => _TodoEditModalState();
}

class _TodoEditModalState extends State<TodoEditModal> {
  final formPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 20);
  final formKey = GlobalKey<FormState>();
  late TodoItem? todoItem;
  late String title;
  late int amount;
  late String? amountUnit;
  late List<Category> categories;

  final TextEditingController amountTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      todoItem = widget.todoItem;
      title = todoItem?.title ?? "";
      amount = todoItem?.amount ?? 0;
      amountUnit = todoItem?.amountUnit;
      categories = todoItem?.categories.toList() ?? [];
      amountTextController.text = amount.toString();
    });

    amountTextController.addListener(() {
      String value = amountTextController.text;

      if (value.isEmpty) {
        amount = 0;
        amountTextController.text = "0";
      } else if (amount == 0 && value != "0" && value.length > 1) {
        value = value.substring(1);
        amount = int.tryParse(value) ?? 0;
        amountTextController.text = value;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    amountTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final String actionName = todoItem == null ? "追加" : "更新";

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: formPadding,
                child: TextFormField(
                  key: const Key("NewItemTitle"),
                  keyboardType: TextInputType.text,
                  initialValue: todoItem?.title,
                  autofocus: true,
                  decoration: const InputDecoration(
                    label: Text("名前"),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "入力してください";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      title = value.trim();
                    });
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: formPadding,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          key: const Key("NewItemAmount"),
                          keyboardType: TextInputType.number,
                          // initialValue: todoItem?.amount.toString(),
                          controller: amountTextController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            if (int.tryParse(value) == null) {
                              return "数字を入力してください";
                            }
                            return null;
                          },
                          autofocus: false,
                          decoration: const InputDecoration(
                            label: Text("個数"),
                          ),
                          onChanged: (value) {
                            value = value.trim();
                            if (value.isNotEmpty && amount == 0) {
                              value = value.substring(1);
                            }
                            setState(() {
                              amount = int.tryParse(value.trim()) ?? 0;
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          key: const Key("NewItemAmountUnit"),
                          keyboardType: TextInputType.text,
                          initialValue: todoItem?.amountUnit,
                          autofocus: false,
                          enabled: amount > 0,
                          decoration: const InputDecoration(
                            label: Text("単位"),
                          ),
                          onChanged: (value) {
                            setState(() {
                              amountUnit = value.trim();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: formPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("カテゴリー"),
                    const SizedBox(height: 6),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (Category category in categories) ...{
                          Container(
                            decoration: BoxDecoration(
                                color: category.color,
                                borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 18.0,
                                    width: 18.0,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0.0),
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          categories.removeWhere((element) =>
                                              element.id == category.id);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(category.title),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8, height: 34),
                        },
                        SizedBox(
                          height: 26.0,
                          width: 26.0,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return CategoryChooser(
                                        itemCategories: categories);
                                  }).then((value) => {
                                    if (value != null &&
                                        categories
                                            .where((element) =>
                                                element.id == value.id)
                                            .isEmpty)
                                      {
                                        setState(() {
                                          categories.add(value);
                                        })
                                      }
                                  });
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 50, bottom: 60, left: 50),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: (formKey.currentState?.validate() == true)
                      ? () {
                          Navigator.pop(
                            context,
                            TodoItem(
                              title: title,
                              createAt: todoItem?.createAt ?? DateTime.now(),
                              isCompleted: todoItem?.isCompleted ?? false,
                              index: todoItem?.index ?? 0x7FFFFFFFFFFFFFFF,
                              amount: amount,
                              amountUnit: amountUnit,
                              categories: categories,
                            ),
                          );
                        }
                      : null,
                  child: Text(actionName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown(List<Category> itemCategories, List<Category> categories) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          '追加',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: categories.map((category) {
          return DropdownMenuItem(
            value: category.title,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = itemCategories.contains(category);
                return InkWell(
                  onTap: () {
                    isSelected
                        ? itemCategories
                            .removeWhere((element) => element.id == category.id)
                        : itemCategories.add(category);
                    setState(() {});
                    menuSetState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_box_outlined)
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
        value: itemCategories.isEmpty ? null : itemCategories.last.title,
        onChanged: (value) {},
        selectedItemBuilder: (context) {
          return categories.map(
            (item) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  itemCategories.map((e) => e.title).join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              );
            },
          ).toList();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(left: 16, right: 8),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
