import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_managment/model/transactions/transaction_model.dart';

// ignore: constant_identifier_names
const TRANSACTIONS_DB_NAME = "transaction-db";

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel value);
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  Future<void> refresh() async {
    final _list = await getAllTransaction();
    _list.sort((first, second) => first.date.compareTo(second.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> addTransaction(TransactionModel value) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    await _db.put(value.id, value);
  }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
