import 'package:pet_care/models/cart_model.dart';

import '../widgets/cartItem.dart';

class Order {
  int? id;
  String? address;
  String? city;
  String? country;
  String? zipCode;
  double? orderPrice;
  int? itemQuantity;
  int? isPaid;
  int? isCompleted;
  String? dateOrder;

  Order({
    this.id,
    required this.address,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.orderPrice,
    required this.itemQuantity,
    required this.isPaid,
    required this.isCompleted,
    required this.dateOrder
  });
}