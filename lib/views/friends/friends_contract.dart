import 'package:debt_frontend/models/friend.dart';

abstract class FriendsContract {
  void showError(String message);
  void onRequestAnswered();
  void updatePage();
}