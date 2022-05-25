import 'package:hive_flutter/hive_flutter.dart';

import '../model/transaction_item.dart';

class LocalStorageService {
  static const String transactionsBoxKey = "transactionsBox";
  static const String balanceBoxKey = "balanceBox";
  static const String budgetBoxKey = "budgetBoxKey";

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }
  LocalStorageService._internal();
  // LocalStorageService._internal() {
  //   initializeHive();
  // }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionItemAdapter());
    }

    await Hive.openBox<double>(budgetBoxKey);
    await Hive.openBox<TransactionItem>(transactionsBoxKey);
    await Hive.openBox<double>(balanceBoxKey);
  }

  void saveTransactionItem(TransactionItem transaction) {
    Hive.box<TransactionItem>(transactionsBoxKey).add(transaction);
    saveBalance(transaction);
  }

  List<TransactionItem> getAllTransactions() {
    return Hive.box<TransactionItem>(transactionsBoxKey).values.toList();
  }

  double getBudget() {
    return Hive.box<double>(budgetBoxKey).get("budget") ?? 2000.0;
  }

  Future<void> saveBudget(double budget) {
    return Hive.box<double>(budgetBoxKey).put("budget", budget);
  }

  double getBalance() {
    return Hive.box<double>(balanceBoxKey).get("balance") ?? 0.0;
  }

  Future<void> saveBalance(TransactionItem item) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
    if (item.isExpense) {
      balanceBox.put("balance", currentBalance - item.amount);
    } else {
      balanceBox.put("balance", currentBalance + item.amount);
    }
  }

  Future<void> saveBalanceOnDelete(TransactionItem item) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);

    final currentBalance = balanceBox.get("balance") ?? 0.0;
    balanceBox.put("balance", currentBalance + item.amount);
    // if (Hive.openBox<TransactionItem>(transactionsBoxKey).toString() == "") {
    //   balanceBox.put("balance", 0.0);
    // }
  }

  Future<void> deleteTransactionItem(TransactionItem item) async {
    final transactions = Hive.box<TransactionItem>(transactionsBoxKey);
    final transInt = Hive.box<TransactionItem>(transactionsBoxKey).length;
    // final transactionsBool =
    //     Hive.box<TransactionItem>(transactionsBoxKey).isEmpty;
    final balanceBox = Hive.box<double>(balanceBoxKey);

    final Map<dynamic, TransactionItem> map = transactions.toMap();
    dynamic desiredKey;
    map.forEach((key, value) {
      if (value.text == item.text) desiredKey = key;
    });
    transactions.delete(desiredKey);
    saveBalanceOnDelete(item);

    if (transInt == 0) {
      balanceBox.put("balance", 0.0);
    }
  }
}
