import 'package:debt_frontend/models/friend.dart';
import 'package:debt_frontend/models/friend_request.dart';
import 'package:debt_frontend/repository/friends_repository.dart';
import 'package:debt_frontend/views/friends/friends_contract.dart';

class FriendsPresenter {
    final FriendsContract _view;
    final FriendsRepository _friendsRepository = FriendsRepository();
    List<Friend> _friends = [];
    List<FriendRequest> _requests = [];

    FriendsPresenter(this._view) {
        reloadData();
    }

    void reloadData() {
        _loadFriends();
        _loadRequests();
    }

    void sendFriendRequest(String username) {
        _view.onRequestAnswered();
        _friendsRepository.sendFriendRequest(username).then((value) {
            reloadData();
            _view.updatePage();
        }).onError((error, stackTrace) {
            _view.showError(error.toString());
        });
    }

    void rejectFriendRequest(String username) {
        _view.onRequestAnswered();
        _friendsRepository.rejectFriendRequest(username).then((value) {
            _requests.removeWhere((request) => request.senderUsername == username);
            _view.updatePage();
        }).onError((error, stackTrace) {
            _view.showError(error.toString());
        });
    }

    List<Friend> getFriends() {
        return _friends;
    }

    List<FriendRequest> getRequests() {
        return _requests;
    }

    void _loadFriends() {
        _friendsRepository.getFriends().then((friends) {
            _friends = friends;
            _view.updatePage();
        }).onError((error, stackTrace) {
            _view.showError(error.toString());
        });
    }

    void _loadRequests() {
        _friendsRepository.getFriendRequests().then((requests) {
            _requests = requests;
            _view.updatePage();
        }).onError((error, stackTrace) {
            _view.showError(error.toString());
        });
    }
}