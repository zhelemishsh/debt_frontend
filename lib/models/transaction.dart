class CreatedTransaction {
  CreatedTransaction(this.amount, this.description);

  double amount;
  String description;

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "amount": amount
    };
  }
}

class Transaction {
  Transaction(
      this.id,
      this.amount,
      this.description,
      this.date,
      this.senderUsername,
      this.receiverUsername);

  int id;
  double amount;
  String description;
  DateTime date;
  String senderUsername;
  String receiverUsername;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        json['id'],
        json['amount'],
        json['description'],
        DateTime.parse(json['date']),
        json['sender_username'],
        json['receiver_username']
    );
  }
}