import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double monthlyBudget = 0.0;
  double totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    fetchBudgetData();
    fetchTotalExpenses();
  }

  Future<void> fetchBudgetData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final budgetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        monthlyBudget = budgetDoc.data()?['monthlyBudget'] ?? 0.0;
      });
    }
  }

  Future<void> fetchTotalExpenses() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentDate = DateTime.now();
      final startOfMonth = DateTime(currentDate.year, currentDate.month, 1);

      final transactions = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('type', isEqualTo: 'Debit')
          .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
          .get();

      double expenses = transactions.docs.fold(0.0, (sum, doc) {
        return sum + (doc['amount'] as num).toDouble();
      });

      setState(() {
        totalExpenses = expenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.6),
              Colors.green.withOpacity(0.6)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Padding to avoid content sticking to the edges
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Displaying Monthly Budget with white text for contrast
                Text(
                  'Monthly Budget: ₹${monthlyBudget.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Displaying Total Expenses in red color to highlight
                Text(
                  'Total Expenses: ₹${totalExpenses.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Displaying Remaining Balance in green color
                Text(
                  'Remaining Balance: ₹${(monthlyBudget - totalExpenses).toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
