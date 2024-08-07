class Credit {
  String cardNumber;
  String expiryDate;
  String cardHolderName;

  Credit({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
  });

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
    };
  }

  factory Credit.fromMap(Map<String, dynamic> map) {
    return Credit(
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cardHolderName: map['cardHolderName'],
    );
  }
}