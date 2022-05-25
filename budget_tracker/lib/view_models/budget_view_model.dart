import 'package:budget_tracker/model/transaction_item.dart';
import 'package:budget_tracker/services/local_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetViewModel extends ChangeNotifier {
  double getBudget() => LocalStorageService().getBudget();
  double getBalance() => LocalStorageService().getBalance();
  List<TransactionItem> get items => LocalStorageService().getAllTransactions();
  set budget(double value) {
    LocalStorageService().saveBudget(value);
    notifyListeners();
  }
  // set balance(){
  //   LocalStorageService().saveBudget(0);
  //   notifyListeners();
  // }
  void addItem(TransactionItem item) {
    LocalStorageService().saveTransactionItem(item);
    notifyListeners();
  }

  void deleteItem(TransactionItem item) {
    final localStorage = LocalStorageService();
    localStorage.deleteTransactionItem(item);
    notifyListeners();
  }
}
