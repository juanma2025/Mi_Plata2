import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import 'package:uuid/uuid.dart';

final transactionsProvider = NotifierProvider<TransactionsNotifier, List<TransactionModel>>(() {
  return TransactionsNotifier();
});

class TransactionsNotifier extends Notifier<List<TransactionModel>> {
  static const _storageKey = 'saved_transactions';

  @override
  List<TransactionModel> build() {
    _loadTransactions();
    return [];
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      state = decoded.map((e) => TransactionModel.fromJson(e)).toList();
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void addTransaction(TransactionModel transaction) {
    state = [transaction, ...state];
    _saveTransactions();
  }
}
