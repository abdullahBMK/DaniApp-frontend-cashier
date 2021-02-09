import 'package:deliveryboy/src/models/food_order.dart';

import '../models/address.dart';
import '../models/product_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  double orderTime;
  double coupon;
  String hint;
  String driverId;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      driverId = jsonMap['driver_id'] != 'null' ? jsonMap['driver_id'].toString() : null;
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      orderTime = jsonMap['order_time'] != null ? double.parse( jsonMap['order_time'] ) : 0.0;
      coupon = jsonMap['coupon_discount'] != null ? jsonMap['coupon_discount'].toDouble() : 0.0;
      hint = jsonMap['hint'] == null ? '' : jsonMap['hint'];
      orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : new OrderStatus();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : new Payment(null);
      deliveryAddress =
          jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      foodOrders = jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders']).map((element) => FoodOrder.fromJSON(element)).toList()
          : [];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    map["delivery_address_id"] = deliveryAddress.id;
    return map;
  }

  Map orderEditortoMap() {
    var map = new Map<String, dynamic>();
    // map["id"] = id;
    // map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["driver_id"] = driverId;
    map["status"] = payment.status;
    map["tax"] = tax;
    map["delivery_fee"] = deliveryFee;
    map["order_time"] = orderTime;
    map["hint"] = hint;
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = 5;
    return map;
  }
}
