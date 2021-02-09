class TakeOrder {
  String orderId;
  String driverId;


  TakeOrder();

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["order_id"] = orderId;
    map["driver_id"] = driverId;

    return map;
  }
}
