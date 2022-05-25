import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddBudgetDialog extends StatefulWidget {
  final Function(double) budgetToAdd;
  const AddBudgetDialog({required this.budgetToAdd, Key? key})
      : super(key: key);

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final TextEditingController _amountBudget = TextEditingController();

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
                "Add Budget",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _amountBudget,
                keyboardType: TextInputType.text,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: "Budget in \$"),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: (() {
                    if (_amountBudget.text.isNotEmpty) {
                      widget.budgetToAdd(double.parse(_amountBudget.text));
                      Navigator.pop(context);
                    }
                  }),
                  child: const Icon(Icons.add))
            ]),
          )),
    );
  }
}
