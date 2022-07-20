import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/screens/catagory/widgets/expense_catagory_list.dart';
import 'package:money_managment/screens/catagory/widgets/income_catagory_list.dart';

class ScreenCatagory extends StatefulWidget {
  const ScreenCatagory({Key? key}) : super(key: key);

  @override
  State<ScreenCatagory> createState() => _ScreenCatagoryState();
}

class _ScreenCatagoryState extends State<ScreenCatagory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: "INCOME",
            ),
            Tab(
              text: "EXPENSES",
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              IncomeCatagoryList(),
              ExpenseCatogoryList(),
            ],
          ),
        )
      ],
    );
  }
}
