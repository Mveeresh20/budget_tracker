import 'package:budget_tracker/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double creditTotal = 0;
  double debitTotal = 0;
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactionSummary();
  }

  Future<void> _loadTransactionSummary() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    double credit = 0;
    double debit = 0;
    List<Map<String, dynamic>> transactions = [];

    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'Credit') {
        credit += data['amount'];
      } else {
        debit += data['amount'];
      }
      transactions.add(data);
    });

    setState(() {
      creditTotal = credit;
      debitTotal = debit;
      recentTransactions = transactions;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Sign out the user.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    ); // Navigate back to the login screen.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.5),
            Colors.purple.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Transaction Summary'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed:
                    _logout, // Trigger logout when the button is pressed.
                tooltip: 'Logout',
              ),
            ],
          ),
          body: Column(
            children: [
              BalanceCard(creditTotal: creditTotal, debitTotal: debitTotal),
              Expanded(
                child: ListView(
                  children: recentTransactions.map((transaction) {
                    return TransactionItem(
                      name: transaction['title'],
                      amount: (transaction['type'] == 'Credit' ? "+₹" : "-₹") +
                          transaction['amount'].toString(),
                      isCredit: transaction['type'] == 'Credit',
                      description: transaction['category'],
                      categoryIcon: Icons.category,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
