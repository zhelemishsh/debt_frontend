import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/transaction.dart';
import 'package:debt_frontend/repository/friends_repository.dart';
import 'package:debt_frontend/repository/transactions_repository.dart';
import 'package:debt_frontend/views/friend_info/friend_info_contract.dart';

class FriendInfoPresenter {
  final FriendInfoContract _view;
  final TransactionRepository _transactionRepository = TransactionRepository();
  final FriendsRepository _friendsRepository = FriendsRepository();
  Friend _friend;
  List<Transaction> _transactions = [];

  FriendInfoPresenter(this._view, this._friend) {
    _loadFriend(_friend.login);
    _loadTransactions(_friend.login);
  }

  List<Transaction> getTransactions() {
    return _transactions;
  }

  Friend getFriend() {
    return _friend;
  }
  
  void renameFriend(String newName) {
    _friendsRepository.renameFriend(_friend.login, newName).then((friend) {
      _friend.name = newName;
      _view.update();
    }).onError((error, stackTrace) {
      _view.showError(error.toString());
    });
  }

  void removeFriend(String friendUsername) {
    _friendsRepository.removeFriend(friendUsername)
        .then((friend) => _view.closePage())
        .onError((error, stackTrace) => _view.showError(error.toString()));
  }

  void deleteTransaction(int transactionId) {
    _transactionRepository.deleteTransaction(transactionId).then((friend) {
      _transactions.removeWhere((transaction) => transaction.id == transactionId);
      _view.update();
    }).onError((error, stackTrace) {
      _view.showError(error.toString());
    });
  }

  void _loadFriend(String friendUsername) {
    _friendsRepository.getFriend(friendUsername).then((friend) {
      _friend = friend;
      _view.update();
    }).onError((error, stackTrace) {
      _view.showError(error.toString());
    });
  }

  void _loadTransactions(String friendUsername) {
    _transactionRepository.getTransactions(friendUsername).then((transactions) {
      _transactions = transactions;
      _view.update();
    }).onError((error, stackTrace) {
      _view.showError(error.toString());
    });
  }
}