import 'package:hive/hive.dart';
part 'transaction_item.g.dart'; // Make sure to include this

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String text;
  @HiveField(1)
  double amount;
  @HiveField(2)
  bool isExpense;
  TransactionItem(
      {required this.amount, required this.text, this.isExpense = true});
}
