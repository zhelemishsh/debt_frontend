class Friend {
  Friend(this.login, this.name, this.debt);

  String name;
  String login;
  double debt;

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        json['username'],
        json['name'],
        json['debt']);
  }
}