import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider_demo/item.dart';
import 'package:http/http.dart' as http;

class ItemViewModel extends ChangeNotifier {
  List<Item> _item = [];
  List<Item> get item => _item;

  Future<void> fetchItems() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _item = data.map((item) => Item.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> addItem(Item item) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    if (response.statusCode == 201) {
      _item.add(item);
      notifyListeners();
    } else {
      throw Exception('Failed to add item');
    }
  }

  Future<void> updateItem(Item item) async {
    final uri = Uri.parse('https://api.example.com/items/${item.id}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final index = _item.indexWhere((i) => i.id == item.id);
      _item[index] = item;
      notifyListeners();
    } else {
      throw Exception('Failed to update item');
    }
  }

  Future<void> deleteItem(int id) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      _item.removeWhere((item) => item.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete item');
    }
  }
}
