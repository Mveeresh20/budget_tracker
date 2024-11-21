import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double creditTotal;
  final double debitTotal;

  BalanceCard({
    required this.creditTotal,
    required this.debitTotal,
  });

  @override
  Widget build(BuildContext context) {
    final totalBalance = creditTotal - debitTotal;

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance: ₹${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit: ₹${creditTotal.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                Text(
                  'Debit: ₹${debitTotal.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
