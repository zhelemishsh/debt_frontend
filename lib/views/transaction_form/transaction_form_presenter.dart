import 'package:debt_frontend/models/transaction.dart';
import 'package:debt_frontend/repository/transactions_repository.dart';
import 'package:debt_frontend/views/transaction_form/transaction_form_contract.dart';

class TransactionFormPresenter {
  final TransactionFormContract _view;
  final TransactionRepository _transactionRepository = TransactionRepository();

  TransactionFormPresenter(this._view);

  void makeTransaction(String friendUsername, CreatedTransaction transaction) {
    _transactionRepository.makeTransaction(friendUsername, transaction)
        .then((value) => _view.onTransactionSent())
        .onError((error, stackTrace) => _view.showError(error.toString()));
  }
}