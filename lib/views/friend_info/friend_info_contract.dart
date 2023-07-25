import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/transaction.dart';

abstract class FriendInfoContract {
  void showError(String message);
  void update();
  void closePage();
}