class Reminder {
  final int id;
  final String productName;
  final DateTime expirationDate;
  final DateTime notificationTime;
  final String description;


  Reminder({
    required this.id,
    required this.productName,
    required this.expirationDate,
    required this.notificationTime,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    // 'id': id, // id is taken care by SQFlite
    'productName': productName,
    'expirationDate': expirationDate.toString(),
    'notificationTime': notificationTime.toString(),
    'description': description,
  };

  static Reminder fromJson(Map<String,dynamic> json) => Reminder(
    id: json['id'],
    productName: json['productName'],
    notificationTime: DateTime.parse(json['notificationTime']),
    expirationDate: DateTime.parse(json['expirationDate']),
    description: json['description'],
  );
}