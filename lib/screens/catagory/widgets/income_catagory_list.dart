import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/model/category/category_model.dart';

class IncomeCatagoryList extends StatelessWidget {
  const IncomeCatagoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().incomeCatagoryList,
      builder: (BuildContext context, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (ctx, index) {
            final _category = newList[index];
            return Card(
              elevation: 1,
              child: ListTile(
                title: Text(_category.name),
                trailing: IconButton(
                  onPressed: () {
                    CategoryDB.instance.deleteCategory(_category.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 8,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
