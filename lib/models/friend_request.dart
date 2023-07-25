class FriendRequest {
  FriendRequest(this.id, this.senderUsername);

  int id;
  String senderUsername;

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(json['request_id'], json['sender_username']);
  }
}