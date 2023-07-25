import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/transaction.dart';
import 'package:debt_frontend/views/transaction_form/transaction_form_contract.dart';
import 'package:debt_frontend/views/transaction_form/transaction_form_presenter.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Friend friend;
  final Function(String) onError;
  final Function() updateParent;
  const TransactionForm({
    Key? key,
    required this.friend,
    required this.onError,
    required this.updateParent
  }) : super(key: key);

  @override
  TransactionFormState createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> implements TransactionFormContract {
  double _transactionAmount = 0;
  String _transactionDescription = "";
  final _formKey = GlobalKey<FormState>();
  late TransactionFormPresenter _transactionFormPresenter;

  @override
  void initState() {
    super.initState();
    _transactionFormPresenter = TransactionFormPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Request money"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  decoration: const InputDecoration(
                      hintText: "Description"
                  ),
                  onChanged: (text) {
                    _transactionDescription = text;
                  }
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Amount"
                      ),
                      onChanged: (text) {
                        double? parsedValue = double.tryParse(text);
                        if (parsedValue != null) {
                          _transactionAmount = parsedValue;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Amount must be a number';
                        }
                        return null;
                      },
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _transactionFormPresenter.makeTransaction(
                            widget.friend.login,
                            CreatedTransaction(
                                _transactionAmount,
                                _transactionDescription)
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 35,
                      color: Color.fromRGBO(0, 195, 6, 1),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  @override
  void showError(String message) {
    widget.onError(message);
  }

  @override
  void onTransactionSent() {
    widget.updateParent();
  }
}