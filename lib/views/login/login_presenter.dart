import 'package:debt_frontend/repository/accounts_repository.dart';

import 'login_contract.dart';

class LoginPresenter {
  final LoginContract _view;
  final AccountsRepository _accountRepository = AccountsRepository();

  LoginPresenter(this._view);

  void loginAccount(String username, String password) {
    _accountRepository.loginAccount(username, password)
        .then((friends) => _view.onLoginSucceeded())
        .onError((error, stackTrace) => _view.onLoginFailed());
  }
}