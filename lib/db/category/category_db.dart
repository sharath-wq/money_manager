import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_managment/model/category/category_model.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = "category_database";

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCatagoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCatagoryList = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _catogoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _catogoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _catogoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _catogoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategory = await getCategories();
    incomeCatagoryList.value.clear();
    expenseCatagoryList.value.clear();
    await Future.forEach(
      _allCategory,
      (CategoryModel _category) {
        if (_category.type == CategoryType.income) {
          incomeCatagoryList.value.add(_category);
        } else {
          expenseCatagoryList.value.add(_category);
        }
      },
    );

    incomeCatagoryList.notifyListeners();
    expenseCatagoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryId);
    refreshUI();
  }
}
