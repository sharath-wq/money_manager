import 'package:flutter/material.dart';
import 'package:money_managment/screens/catagory/screen_catagory.dart';
import 'package:money_managment/screens/catagory/widgets/catagory_add_popup.dart';
import 'package:money_managment/screens/home/widgets/bottom_navigation.dart';
import 'package:money_managment/screens/transactions/screen_transactions.dart';
import 'package:money_managment/screens/transactions/widget/screen_add_transactions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final _pages = const [ScreenTransactions(), ScreenCatagory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("MONEY MANAGER"),
        centerTitle: true,
        leading: const Icon(Icons.money),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndex.value == 0) {
            // print("Add Transactions");
            Navigator.of(context).pushNamed(ScreenAddTransactions.routeName);
          } else if (selectedIndex.value == 1) {
            // print("Add Catogory");
            // final _sample = CategoryModel(
            //   id: DateTime.now().microsecondsSinceEpoch.toString(),
            //   name: "Traval",
            //   type: CategoryType.expenses,
            // );
            // CategoryDB().insertCategory(_sample);
            showCatagoryAddPopup(context);
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (BuildContext ctx, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    );
  }
}
