import 'dart:ffi';

class InventoryItem {
  final int? id;
  final String name;
  // final String description;
  final String category;
  final String image;
  final int givenAway;

  InventoryItem({
    this.id,
    required this.name,
    // required this.description,
    required this.category,
    required this.image,
    required this.givenAway,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      // description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      givenAway: json['givenAway'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'description': description,
      'category': category,
      'image': image,
      'givenAway': givenAway,
    };
  }
}

class MoneyItem {
  final int? id;
  final String name;
  final int quantity;
  final double amount;

  MoneyItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.amount,
  });

  factory MoneyItem.fromJson(Map<String, dynamic> json) {
    return MoneyItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      amount: json['amount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'amount': amount,
    };
  }
}
