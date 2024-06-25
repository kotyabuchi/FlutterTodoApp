// ignore_for_file: file_names
import 'package:flutter/material.dart';

class Category {
  int id;
  String title;
  Color color;

  Category({required this.id, required this.title, this.color = Colors.white});

  static List<Category> getDummy() {
    return [
      Category(
          id: 0, title: "魚", color: const Color.fromARGB(255, 165, 226, 255)),
      Category(
          id: 1, title: "野菜", color: const Color.fromARGB(255, 201, 231, 167)),
      Category(
          id: 2, title: "お肉", color: const Color.fromARGB(255, 255, 182, 177)),
      Category(
          id: 3, title: "飲み物", color: const Color.fromARGB(255, 193, 109, 64)),
      Category(
          id: 4, title: "調味料", color: const Color.fromARGB(255, 204, 255, 177)),
      Category(
          id: 5, title: "冷凍", color: const Color.fromARGB(255, 177, 255, 226)),
    ];
  }

  @override
  String toString() {
    return {"id": id, "title": title, "color": color.toString()}.toString();
  }
}
