import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String amount;
  final bool isCredit;
  final String description;
  final IconData categoryIcon;

  TransactionItem({
    required this.name,
    required this.amount,
    required this.isCredit,
    required this.description,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(categoryIcon),
      title: Text(name),
      subtitle: Text(description),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
