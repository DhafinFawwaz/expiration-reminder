class Reminder {
  String id;
  final String productName;
  final DateTime expirationDate;
  final DateTime notificationTime;
  final String description;

  final bool hasExpired;

  Reminder({
    this.id = '',
    required this.productName,
    required this.expirationDate,
    required this.notificationTime,
    required this.description,
    required this.hasExpired,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'expirationDate': expirationDate,
    'notificationTime': notificationTime,
    'description': description,
    'hasExpired': hasExpired,
  };

  static Reminder fromJson(Map<String,dynamic> json) => Reminder(
    id: json['id'],
    productName: json['productName'],
    notificationTime: json['notificationTime'],
    expirationDate: json['expirationDate'],
    description: json['description'],
    hasExpired: json['hasExpired'],
  );
}