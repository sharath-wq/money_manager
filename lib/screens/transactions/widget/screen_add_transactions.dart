import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/db/transactions/transaction_db.dart';
import 'package:money_managment/model/category/category_model.dart';
import 'package:money_managment/model/transactions/transaction_model.dart';

class ScreenAddTransactions extends StatefulWidget {
  const ScreenAddTransactions({Key? key}) : super(key: key);
  static const routeName = "add-transactions";

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategory;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingcontroller = TextEditingController();

  String? _categoryId;
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD TRANSACTIONS"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "PURPOSE",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _amountTextEditingcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "AMOUNT",
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final _selectDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365 * 4),
                        ),
                        lastDate: DateTime.now(),
                      );

                      if (_selectDate == null) {
                        return;
                      } else {
                        setState(() {
                          _selectedDate = _selectDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(_selectedDate == null
                        ? "SELECT DATE"
                        : _selectedDate!.toString().substring(0, 10)),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(
                            () {
                              _selectedCategoryType = CategoryType.income;
                              _categoryId = null;
                            },
                          );
                        },
                      ),
                      const Text("Income"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expenses,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(
                            () {
                              _selectedCategoryType = CategoryType.expenses;
                              _categoryId = null;
                            },
                          );
                        },
                      ),
                      const Text("Expense"),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                    hint: const Text("SELECT CATEGORY"),
                    value: _categoryId,
                    items: (_selectedCategoryType == CategoryType.income
                            ? CategoryDB.instance.incomeCatagoryList
                            : CategoryDB.instance.expenseCatagoryList)
                        .value
                        .map(
                      (e) {
                        return DropdownMenuItem(
                          onTap: () {
                            _selectedCategory = e;
                          },
                          value: e.id,
                          child: Text(e.name),
                        );
                      },
                    ).toList(),
                    onChanged: (selectedValue) {
                      setState(
                        () {
                          _categoryId = selectedValue.toString();
                        },
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      addTransactions();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("SUBMIT"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransactions() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingcontroller.text;

    if (_purposeText.isEmpty) {
      return;
    }

    if (_amountText.isEmpty) {
      return;
    }

    if (_categoryId == null) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }

    final _parseAmount = double.tryParse(_amountText);
    if (_parseAmount == null) {
      return;
    }

    if (_selectedCategory == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parseAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategory!,
    );

    await TransactionDB.instance.addTransaction(_model);
    await TransactionDB.instance.refresh();

    Navigator.of(context).pop();
  }
}
