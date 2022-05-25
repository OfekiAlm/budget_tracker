import 'package:budget_tracker/model/transaction_item.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  final TransactionItem item;
  const TransactionCard({required this.item, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(children: [
                  const Text("Delete item"),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        final budgetViewModel = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);
                        budgetViewModel.deleteItem(item);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"))
                ]),
              ),
            );
          })),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                offset: const Offset(0, 25),
                blurRadius: 50,
              )
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text(
                item.text,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                (!item.isExpense ? "+ " : "- ") + "\$" + item.amount.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  const AddTransactionDialog({required this.itemToAdd, Key? key})
      : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController itemTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _isExpenseController = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              const Text(
                "Add an expense",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: itemTitleController,
                decoration: const InputDecoration(hintText: "Name of expense"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: "Amount in \$"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Is expense?"),
                  Switch.adaptive(
                      value: _isExpenseController,
                      onChanged: (b) {
                        setState(() {
                          _isExpenseController = b;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: (() {
                    if (amountController.text.isNotEmpty &&
                        itemTitleController.text.isNotEmpty) {
                      widget.itemToAdd(TransactionItem(
                          amount: double.parse(amountController.text),
                          text: itemTitleController.text,
                          isExpense: _isExpenseController));
                      Navigator.pop(context);
                    }
                  }),
                  child: const Icon(Icons.add))
            ]),
          )),
    );
  }
}
