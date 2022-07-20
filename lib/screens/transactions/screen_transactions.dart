import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/db/transactions/transaction_db.dart';
import 'package:money_managment/model/category/category_model.dart';
import 'package:money_managment/model/transactions/transaction_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemBuilder: (ctx, index) {
              final _values = newList[index];
              return Slidable(
                key: Key(_values.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      foregroundColor: Colors.red,
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(_values.id!);
                      },
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                    SlidableAction(
                      foregroundColor: Colors.blue,
                      onPressed: (ctx) {},
                      icon: Icons.archive_outlined,
                      label: "Archive",
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Text(
                        parseDate(_values.date),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text(
                      "RS ${_values.amount}/-",
                      style: TextStyle(
                          color: _values.type == CategoryType.income
                              ? Colors.green
                              : Colors.red),
                    ),
                    subtitle: Text(_values.category.name),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: newList.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(" ");

    return '${_splitDate.last}\n${_splitDate.first}';
  }
}
