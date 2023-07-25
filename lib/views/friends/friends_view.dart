import 'package:badges/badges.dart' as badges;
import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/views/friend_info/friend_info_view.dart';
import 'package:debt_frontend/views/friends/friends_contract.dart';
import 'package:debt_frontend/views/friends/friends_presenter.dart';
import 'package:debt_frontend/views/transaction_form/transaction_form_view.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  FriendsPageState createState() {
    return FriendsPageState();
  }
}

class FriendsPageState extends State<FriendsPage> implements FriendsContract {
  late FriendsPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = FriendsPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Friends'),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle_rounded, size: 40),
            ),
            actions: [
              if (_presenter.getRequests().isNotEmpty) friendRequestsIcon(),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addFriendPopup();
                    },
                  );
                },
                icon: const Icon(Icons.person_add_rounded, size: 30.0),
              ),
            ],
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: RefreshIndicator(
                displacement: 20,
                onRefresh: () async {
                  _presenter.reloadData();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  separatorBuilder: (BuildContext context, int index) => const Divider(
                    color: Colors.grey, thickness: 1, height: 10,
                  ),
                  itemCount: _presenter.getFriends().length,
                  itemBuilder: (BuildContext context, int index) {
                    return friendBox(_presenter.getFriends()[index]);
                  },
                ),
              ),
          ),
      );
  }

  Widget friendRequestsIcon() {
    return badges.Badge(
      child: IconButton(
        onPressed: () {
          for (int i = 0; i < _presenter.getRequests().length; ++i) {
            showRequestPopup(i);
          }
        },
        icon: const Icon(Icons.email_rounded, size: 30,),
      ),
      position: badges.BadgePosition.bottomEnd(bottom: 3, end: 3),
      badgeContent: Text(
        _presenter.getRequests().length.toString(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void showRequestPopup(int requestNumber) {
    Color? barrierColor;
    double? elevation = 0;
    if (requestNumber == 0) {
      barrierColor = Colors.black54;
      elevation = null;
    }
    showDialog(
      context: context,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: elevation,
          title: Text("Accept ${_presenter.getRequests()[requestNumber].senderUsername}'s request?"),
          content: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    _presenter.rejectFriendRequest(
                        _presenter.getRequests()[requestNumber].senderUsername);
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    _presenter.sendFriendRequest(
                        _presenter.getRequests()[requestNumber].senderUsername);
                  },
                  icon: const Icon(
                    Icons.done_rounded,
                    size: 30,
                    color: Color.fromRGBO(0, 195, 6, 1),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget friendBox(Friend friend) {
      return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => FriendInfoPage(
                          initFriend: friend,
                        ))
                    );
                  },
                  child: Text(
                      friend.name,
                      style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(75, 75, 75, 1)
                      )
                  )
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TransactionForm(
                                    friend: friend,
                                    onError: showError,
                                    updateParent: updatePage
                                );
                              }
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(210, 210, 210, 1),
                        ),
                        child: Text(
                          "${friend.debt}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: friend.debt < 0
                                ? Colors.red
                                : const Color.fromRGBO(0, 195, 6, 1),
                          ),
                        ),
                      ),
                  )
              )
          ]
      );
  }

  Widget addFriendPopup() {
    return AlertDialog(
      title: const Text("Enter username"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Username",
        ),
        onSubmitted: (text) {
          _presenter.sendFriendRequest(text);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
                content: Text(message),
            );
        }
    );
  }

  @override
  void dispose() {
      super.dispose();
  }

  @override
  void updatePage() {
    setState(() {});
  }

  @override
  void onRequestAnswered() {
    Navigator.pop(context);
  }
}