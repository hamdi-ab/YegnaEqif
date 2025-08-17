import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yegna_eqif_new/features/budget/model/budget.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
