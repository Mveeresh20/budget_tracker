import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';

class TransactionService {
  // Method to get transactions for a specific month and year
  Stream<List<TransactionItem>> getTransactionsForMonth(int month, int year) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.empty();

    // Firestore query to get transactions based on the selected month and year
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('month', isEqualTo: month) // Filtering by selected month
        .where('year', isEqualTo: year) // Filtering by selected year
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();
              return TransactionItem(
                name: data['title'],
                amount: (data['amount'] > 0 ? '+₹' : '-₹') +
                    data['amount'].toString(),
                isCredit: data['type'] == 'Credit',
                description: '',
                categoryIcon: Icons.shopping_bag,
              );
            }).toList());
  }
}
