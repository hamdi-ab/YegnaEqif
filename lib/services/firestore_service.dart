import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/bank_account.dart';
import '../models/cash_card.dart';
import '../models/category.dart';
import '../models/total_balance.dart';
import '../models/transaction.dart' as transaction;
import '../models/budget.dart';
import '../models/debt.dart';
import '../utils/firebase_utils.dart';
import '../utils/icon_utils.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Category Methods
  Future<void> addCategory(String userId, String name, IconData icon, Color color) async {
    final String iconString = convertIconToString(icon);
    final String colorHex = convertColorToHex(color);

    await _firestore.collection('users').doc(userId).collection('categories').add({
      'name': name,
      'icon': iconString,
      'color': colorHex,
    });
  }

  Future<List<Category>> fetchCategories(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('categories').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Category(
        id: doc.id,
        name: data['name'],
        icon: convertStringToIcon(data['icon']),
        color: convertHexToColor(data['color']),
      );
    }).toList();
  }

  Future<void> removeCategory(String userId, String categoryId) async {
    await _firestore.collection('users').doc(userId).collection('categories').doc(categoryId).delete();
  }

  Future<void> updateCategory(String userId, String categoryId, Category updatedCategory) async {
    final String iconString = convertIconToString(updatedCategory.icon);
    final String colorHex = convertColorToHex(updatedCategory.color);

    await _firestore.collection('users').doc(userId).collection('categories').doc(categoryId).update({
      'name': updatedCategory.name,
      'icon': iconString,
      'color': colorHex,
    });
  }

  // Transaction Methods
  Future<void> addTransaction(String userId, transaction.Transaction transaction) async {
    await _firestore.collection('users').doc(userId).collection('transactions').add(transaction.toMap());
  }

  Future<List<transaction.Transaction>> fetchTransactions(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('transactions').get();

    return snapshot.docs.map((doc) {
      return transaction.Transaction.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Future<void> removeTransaction(String userId, String transactionId) async {
    await _firestore.collection('users').doc(userId).collection('transactions').doc(transactionId).delete();
  }

  Future<void> updateTransaction(String userId, String transactionId, transaction.Transaction updatedTransaction) async {
    await _firestore.collection('users').doc(userId).collection('transactions').doc(transactionId).update(updatedTransaction.toMap());
  }

  // Budget Methods
  Future<void> addBudget(String userId, Budget budget) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .add(budget.toMap());

    await docRef.update({'id': docRef.id});
  }

  Future<List<Budget>> fetchBudgets(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Budget.fromMap(data..['id'] = doc.id);
    }).toList();
  }

  Future<void> removeBudget(String userId, String budgetId) async {
    await _firestore.collection('users').doc(userId).collection('budgets').doc(budgetId).delete();
  }

  Future<void> updateBudget(String userId, String budgetId, Budget updatedBudget) async {
    await _firestore.collection('users').doc(userId).collection('budgets').doc(budgetId).update(updatedBudget.toMap());
  }

  // Debt Methods
  Future<void> addDebt(String userId, Debt debt) async {
    await _firestore.collection('users').doc(userId).collection('debts').add(debt.toFirestore());
  }

  Future<List<Debt>> fetchDebts(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('debts').get();

    return snapshot.docs.map((doc) {
      return Debt.fromFirestore(doc);
    }).toList();
  }

  Future<void> removeDebt(String userId, String debtId) async {
    await _firestore.collection('users').doc(userId).collection('debts').doc(debtId).delete();
  }

  Future<void> updateDebt(String userId, String debtId, Debt updatedDebt) async {
    await _firestore.collection('users').doc(userId).collection('debts').doc(debtId).update(updatedDebt.toFirestore());
  }

  // Bank Account Methods
  Future<void> addBankAccount(String userId, BankAccountCardModel bankAccount) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('bankAccounts')
        .add(bankAccount.toMap());

    await docRef.update({'id': docRef.id});
  }

  Future<List<BankAccountCardModel>> fetchBankAccounts(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('bankAccounts').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BankAccountCardModel(
        id: doc.id,
        accountName: data['accountName'],
        accountNumber: data['accountNumber'],
        balance: data['balance'],
        cardColor: Color(data['cardColor']),
      );
    }).toList();
  }

  Future<void> removeBankAccount(String userId, String bankAccountId) async {
    await _firestore.collection('users').doc(userId).collection('bankAccounts').doc(bankAccountId).delete();
  }

  Future<void> updateBankAccount(String userId, String bankAccountId, BankAccountCardModel updatedBankAccount) async {
    await _firestore.collection('users').doc(userId).collection('bankAccounts').doc(bankAccountId).update(updatedBankAccount.toMap());
  }

  // Cash Card Methods (local storage handled separately)
  Future<void> addCashCard(String userId, CashCardModel cashCard) async {
    await _firestore.collection('users').doc(userId).collection('cashCards').add(cashCard.toMap());
  }

  Future<List<CashCardModel>> fetchCashCards(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('cashCards').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CashCardModel(
        balance: data['balance'],
        cardColor: Color(data['cardColor']),
      );
    }).toList();
  }

  Future<void> removeCashCard(String userId, String cashCardId) async {
    await _firestore.collection('users').doc(userId).collection('cashCards').doc(cashCardId).delete();
  }

  Future<void> updateCashCard(String userId, String cashCardId, CashCardModel updatedCashCard) async {
    await _firestore.collection('users').doc(userId).collection('cashCards').doc(cashCardId).update(updatedCashCard.toMap());
  }

  // Total Balance Card Methods (local storage handled separately)
  Future<void> addTotalBalanceCard(String userId, TotalBalanceCardModel totalBalanceCard) async {
    await _firestore.collection('users').doc(userId).collection('totalBalanceCards').add(totalBalanceCard.toMap());
  }

  Future<List<TotalBalanceCardModel>> fetchTotalBalanceCards(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('totalBalanceCards').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return TotalBalanceCardModel(
        totalBalance: data['totalBalance'],
        income: data['income'],
        expense: data['expense'],
        cardColor: Color(data['cardColor']),
      );
    }).toList();
  }

  Future<void> removeTotalBalanceCard(String userId, String totalBalanceCardId) async {
    await _firestore.collection('users').doc(userId).collection('totalBalanceCards').doc(totalBalanceCardId).delete();
  }

  Future<void> updateTotalBalanceCard(String userId, String totalBalanceCardId, TotalBalanceCardModel updatedTotalBalanceCard) async {
    await _firestore.collection('users').doc(userId).collection('totalBalanceCards').doc(totalBalanceCardId).update(updatedTotalBalanceCard.toMap());
  }
}
