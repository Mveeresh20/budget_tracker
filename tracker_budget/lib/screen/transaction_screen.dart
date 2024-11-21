import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/transaction_item.dart'; // Assuming your custom transaction item widget

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _selectedMonth = DateTime.now().month; // Default to current month
  String _selectedYear = "${DateTime.now().year}"; // Default to current year

  // This method will help to fetch the transactions of a selected month.
  Stream<List<TransactionItem>> getTransactionsForMonth(int month) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.empty();

    DateTime startOfMonth = DateTime(DateTime.now().year, month, 1);
    DateTime endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

    // Fetch transactions for the selected month
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThan: endOfMonth)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <TransactionItem>[]; // Return empty list if no transactions
      }
      // Map Firestore docs to TransactionItem list
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return TransactionItem(
          name: data['title'],
          amount:
              (data['amount'] > 0 ? '+₹' : '-₹') + data['amount'].toString(),
          isCredit: data['type'] == 'Credit',
          description: data['category'] ?? 'Unknown', // Handle missing category
          categoryIcon:
              _getCategoryIcon(data['category']), // Get icon based on category
        );
      }).toList();
    });
  }

  // Method to return category icon based on category type
  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Clothes':
        return Icons.checkroom;
      case 'Travel':
        return Icons.travel_explore;
      case 'Food':
        return Icons.fastfood;
      case 'Entertainment':
        return Icons.movie;
      case 'Rent':
        return Icons.home;
      case 'Groceries':
        return Icons.local_grocery_store;
      case 'Petrol':
        return Icons.local_gas_station;
      case 'Insurance':
        return Icons.security;
      case 'Salary':
        return Icons.money;
      default:
        return Icons.category; // Default category icon
    }
  }

  // A method to handle month selection (e.g., using a dropdown)
  void _selectMonth(int month) {
    setState(() {
      _selectedMonth = month; // Set the selected month
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent background for the entire screen
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
        title: Text(
          'Transactions for $_selectedYear - $_selectedMonth',
          style: TextStyle(color: Colors.black), // White text for contrast
        ),
        actions: [
          // Dropdown for month selection
          DropdownButton<int>(
            value: _selectedMonth,
            dropdownColor:
                Colors.black.withOpacity(0.8), // Dropdown background color
            style: TextStyle(color: Colors.red), // White text in the dropdown
            items: List.generate(12, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('Month ${index + 1}'),
              );
            }),
            onChanged: (month) {
              if (month != null) {
                _selectMonth(month); // Update the month when selected
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(184, 29, 13, 1)
              .withOpacity(0.5), // Semi-transparent dark background overlay
          // You can also add a gradient or use an image as background here
        ),
        child: StreamBuilder<List<TransactionItem>>(
          stream: getTransactionsForMonth(_selectedMonth),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No transactions found for this month.'));
            }

            var transactions = snapshot.data!;

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return Card(
                  color: Colors.white
                      .withOpacity(0.8), // Semi-transparent white card
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 6,
                  child: ListTile(
                    leading: Icon(transaction.categoryIcon),
                    title: Text(transaction.name),
                    subtitle: Text(transaction.description),
                    trailing: Text(transaction.amount),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
