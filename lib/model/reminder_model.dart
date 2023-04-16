class Reminder {
  final int id;
  final String productName;
  final String productAlias;
  final DateTime expirationDate;
  final DateTime notificationTime;
  final String type; //Manual | QrCode


  Reminder({
    required this.id,
    required this.productName,
    required this.productAlias,
    required this.expirationDate,
    required this.notificationTime,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    // 'id': id, // id is taken care by SQFlite
    'productName': productName,
    'productAlias': productAlias,
    'expirationDate': expirationDate.toString(),
    'notificationTime': notificationTime.toString(),
    'type': type,
  };

  static Reminder fromJson(Map<String,dynamic> json) => Reminder(
    id: json['id'],
    productName: json['productName'],
    productAlias: json['productAlias'],
    notificationTime: DateTime.parse(json['notificationTime']),
    expirationDate: DateTime.parse(json['expirationDate']),
    type: json['type'],
  );
}