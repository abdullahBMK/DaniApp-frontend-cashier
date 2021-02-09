class OrderStatusUpdate {
  String id;
  String orderStatusId;

  OrderStatusUpdate();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = orderStatusId;

    return map;
  }
}
