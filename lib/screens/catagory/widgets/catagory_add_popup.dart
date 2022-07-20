import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/model/category/category_model.dart';

ValueNotifier<CategoryType> selectedCatagoryNotifier =
    ValueNotifier(CategoryType.income);

final _nameEditingController = TextEditingController();

Future<void> showCatagoryAddPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("ADD CATAGORY"),
            IconButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _nameEditingController.clear();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: const InputDecoration(
                hintText: "Catagory name: ",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(title: "Income", type: CategoryType.income),
                RadioButton(title: "Expenses", type: CategoryType.expenses),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text.trim();
                final _type = selectedCatagoryNotifier.value;

                if (_name.isEmpty) {
                  return;
                }
                final _catagory = CategoryModel(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: _name,
                  type: _type,
                );
                CategoryDB().insertCategory(_catagory);
                Navigator.of(ctx).pop();
                _nameEditingController.clear();
              },
              child: const Text("ADD"),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  // final CategoryType selectedType;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCatagoryNotifier,
          builder:
              (BuildContext context, CategoryType newCatagory, Widget? child) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCatagory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCatagoryNotifier.value = value;
                selectedCatagoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
