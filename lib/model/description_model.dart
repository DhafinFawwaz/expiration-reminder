class Description {
  final int id;
  final String productName;
  final String description;


  Description({
    required this.id,
    required this.productName,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    // 'id': id, // id is taken care by SQFlite
    'productName': productName,
    'description': description,
  };

  static Description fromJson(Map<String,dynamic> json) => Description(
    id: json['id'],
    productName: json['productName'],
    description: json['description'],
  );
}