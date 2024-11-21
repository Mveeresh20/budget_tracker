import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';

class WidgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Widgets')),
      body: Column(
        children: [
          BalanceCard(debitTotal: 1000, creditTotal: 100000),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                TransactionItem(
                  name: "Car rent Oct 23",
                  amount: "8000",
                  isCredit: true,
                  description: "No",
                  categoryIcon: Icons.cast_for_education,
                ),
                TransactionItem(
                  name: "B.Tech fee last sem",
                  amount: "5000",
                  isCredit: false,
                  description: "veeresh",
                  categoryIcon: Icons.cast_for_education,
                ),
                TransactionItem(
                  name: "Salary month of Sep 23",
                  amount: "35000",
                  isCredit: true,
                  description: "hello",
                  categoryIcon: Icons.money,
                ),
                TransactionItem(
                  name: "Electricity bill Sep 23",
                  amount: "3000",
                  isCredit: false,
                  description: "vee",
                  categoryIcon: Icons.electric_bike,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
