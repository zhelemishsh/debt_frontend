import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/transaction.dart';
import 'package:debt_frontend/views/friend_info/friend_info_contract.dart';
import 'package:debt_frontend/views/friend_info/friend_info_presenter.dart';
import 'package:debt_frontend/views/friends/friends_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class FriendInfoPage extends StatefulWidget {
  final Friend initFriend;

  const FriendInfoPage({
    Key? key, required this.initFriend
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendInfoPageState();
  }
}

class FriendInfoPageState extends State<FriendInfoPage> implements FriendInfoContract {
  late FriendInfoPresenter _presenter;
  String accountUsername = "Slark";
  final _renameFriendFormKey = GlobalKey<FormState>();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _presenter = FriendInfoPresenter(this, widget.initFriend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: closePage,
          icon: const Icon(Icons.arrow_back_rounded, size: 30),
        ),
        title: Row(
          children: [
            Text(_presenter.getFriend().name),
            Text(
              " aka ${_presenter.getFriend().login}",
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () { showFriendRenamePopup(); },
            icon: const Icon(Icons.drive_file_rename_outline_rounded, size: 30),
          ),
          IconButton(
            onPressed: () { showFriendDeletePopup(); },
            icon: removePersonIcon(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Colors.grey, thickness: 1, height: 0,
          ),
          itemCount: _presenter.getTransactions().length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: const Color.fromRGBO(0, 0, 255, 0.08),
              child: Ink(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: transactionBox(index),
                decoration: getDecoration(index),
              ),
              onLongPress: () {
                if (_selectedIndex != index) {
                  _selectedIndex = index;
                }
                else {
                  _selectedIndex = -1;
                }
                setState(() {});
              },
            );
          },
        ),
      ),
      floatingActionButton: deleteButton(),
    );
  }

  FloatingActionButton? deleteButton() {
    if (_selectedIndex == -1
        || _presenter.getTransactions()[_selectedIndex].senderUsername != accountUsername) {
      return null;
    }
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.delete_rounded,
        color: Colors.red,
        size: 30,
      ),
      onPressed: () {
        if (_selectedIndex != -1) {
          _presenter.deleteTransaction(_presenter.getTransactions()[_selectedIndex].id);
          _selectedIndex = -1;
        }
      },
    );
  }

  BoxDecoration getDecoration(int index) {
    if (index == _selectedIndex) {
      return const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(0, 0, 255, 0.0), // yellow sun
              Color.fromRGBO(0, 0, 255, 0.08),
              Color.fromRGBO(0, 0, 255, 0.08),
              Color.fromRGBO(0, 0, 255, 0.0),// blue sky
            ],
            stops: [
              0.0, 0.1, 0.9, 1.0
            ]
        ),
      );
    }
    else {
      return const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0),
      );
    }
  }

  Widget transactionBox(int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: arrow(index),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _presenter.getTransactions()[index].description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(75, 75, 75, 1),
                  ),
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd – kk:mm').format(_presenter.getTransactions()[index].date),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(140, 140, 140, 1),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${_presenter.getTransactions()[index].amount}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _presenter.getTransactions()[index].senderUsername == accountUsername
                    ? const Color.fromRGBO(0, 195, 6, 1)
                    : Colors.red,
              ),
            ),
          )
        )
      ],
    );
  }

  Widget removePersonIcon() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: const Icon(
        Icons.person_remove_rounded, size: 30,
      ),
    );
  }
  

  Widget arrow(int index) {
    if (accountUsername == _presenter.getTransactions()[index].senderUsername) {
      return const Icon(
        Icons.forward_rounded, size: 35, color: Color.fromRGBO(0, 195, 6, 1),
      );
    }
    else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: const Icon(
          Icons.forward_rounded, size: 35, color: Colors.red,
        ),
      );
    }
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

  void showFriendRenamePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter new name"),
            content: Form(
              key: _renameFriendFormKey,
              child: TextFormField(
                autofocus: true,
                onFieldSubmitted: (text) {
                  if (_renameFriendFormKey.currentState!.validate()) {
                    _presenter.renameFriend(text);
                    Navigator.pop(context);
                  }
                },
                decoration: const InputDecoration(
                  hintText: "New name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill in the field';
                  }
                },
              ),
            )
          );
        }
    );
  }

  void showFriendDeletePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove ${_presenter.getFriend().login} from friends?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _presenter.removeFriend(_presenter.getFriend().login);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          )
        );
      },
    );
  }

  @override
  void update() {
    setState(() {});
  }

  @override
  void closePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }
}