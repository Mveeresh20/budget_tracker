import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'transaction_screen.dart';
import 'budget_screen.dart';
import 'package:budget_tracker/widgets/balance_card.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    HomeContent(),
    TransactionScreen(),
    BudgetScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddTransactionDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedType = 'Credit';
    String selectedCategory = 'Clothes';
    final categories = [
      'Clothes',
      'Travel',
      'Food',
      'Entertainment',
      'Rent',
      'Groceries',
      'Petrol',
      'Insurance',
      'Salary',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue ?? 'Credit';
                      });
                    },
                    items: ['Credit', 'Debit']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory ?? 'Clothes';
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String title = titleController.text;
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;

                    if (title.isEmpty || amount <= 0) {
                      // Show an error message or handle the invalid input here
                      return;
                    }

                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Save to Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('transactions')
                          .add({
                        'title': title,
                        'amount': amount,
                        'type': selectedType,
                        'category': selectedCategory,
                        'timestamp': Timestamp.now(),
                        'month': DateTime.now().month,
                        'year': DateTime.now().year,
                      });
                    }

                    Navigator.pop(context);
                  },
                  child: Text('Add Transaction'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar with gradient background
      appBar: AppBar(
        title: Text('Budget Tracker',
            style:
                TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.white
            ], // Light gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_selectedIndex],
      ),
      // Bottom Navigation Bar with custom styling
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      // Floating Action Button with custom style
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple.shade600, // Custom background color
        elevation: 5.0, // Slight shadow for elevation
      ),
    );
  }
}
