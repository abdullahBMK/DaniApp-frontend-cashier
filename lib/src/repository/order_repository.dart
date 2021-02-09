import 'dart:convert';
import 'dart:io';

import 'package:deliveryboy/src/models/driver.dart';
import 'package:deliveryboy/src/models/order_status_update.dart';
import 'package:deliveryboy/src/models/restaurant.dart';
import 'package:deliveryboy/src/models/take_order.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;foodOrders;foodOrders.food;orderStatus;deliveryAddress;user&search=order_status_id:5;foodOrders.food.restaurant_id:${userRepo.currentUser.restaurant.id}&searchFields=order_status_id:<>;foodOrders.food.restaurant_id:=&searchJoin=and&orderBy=id&sortedBy=desc';
      // '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress;user&search=driver.id:${_user.id};order_status_id:$orderStatusId&searchFields=driver.id:=;order_status_id:<>&searchJoin=and&orderBy=id&sortedBy=desc';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
      // print(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<Order>> getPendingOrders() async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress;user&search=order_status_id:$orderStatusId&searchFields=order_status_id:<>&searchJoin=and&orderBy=id&sortedBy=asc&order_has_none_driver';
  // print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
      // print(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<Order>> getOrdersHistory() async {
  final String orderStatusId = "5"; // for delivered status
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      //'${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id};order_status_id:$orderStatusId&searchFields=driver.id:=;order_status_id:=&searchJoin=and&orderBy=id&sortedBy=desc';
   '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;foodOrders;foodOrders.food;orderStatus;deliveryAddress;user&search=order_status_id:5;foodOrders.food.restaurant_id:${userRepo.currentUser.restaurant.id}&searchFields=order_status_id:=;foodOrders.food.restaurant_id:=&searchJoin=and&orderBy=id&sortedBy=desc';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}
//Route::post('update_order', 'API\OrderAPIController@updateOrderStatus');
    // public function updateOrderStatus(Request $request)
    // {
    //     $input = $request->all();

    //     $order = $this->orderRepository->findWithoutFail($input['id']);

    //     if (empty($order)) {
    //         return $this->sendResponse(false, __('lang.saved_successfully', ['operator' => __('lang.order')]));
    //     }
    //     try {
            

    //         if (setting('enable_notifications', false)) {
    //             if ($input['order_status_id'] != $order->order_status_id) {
    //                 $order->order_status_id = $input['order_status_id'];
    //                 $order->save();
    //                 Notification::send([$order->user], new StatusChangedOrder($order));
    //             }
    //         }

            
    //     } catch (ValidatorException $e) {
    //         // Flash::error($e->getMessage());
    //     }

    //     return $this->sendResponse($order->toArray(), __('lang.saved_successfully', ['operator' => __('lang.order')]));
    // }
Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus;deliveryAddress;payment';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  print(url);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getObjectData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Driver>> getDrivers(id) async {
  // User _user = userRepo.currentUser;
  // final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('base_url')}api/getdrivers/$id';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  print(url);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      // .map((data) => Helper.getObjectData(data))
      .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
      .map((data) {
    return Driver.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      // '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;productOrders;productOrders.product;orderStatus;deliveryAddress&search=driver.id:${_user.id}&searchFields=driver.id:=&orderBy=id&sortedBy=desc&limit=4';
       '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=driver;foodOrders;foodOrders.food;orderStatus;deliveryAddress;user&search=foodOrders.food.restaurant_id:${userRepo.currentUser.restaurant.id}&searchFields=foodOrders.food.restaurant_id:=&searchJoin=and&orderBy=id&sortedBy=desc&limit=4';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  /*
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });*/
}

Future<Order> deliveredOrder(Order order) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.deliveredMap()),
  );
  print(response.body);
  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<bool> updateOrders(Order order) async {
  // User _user = userRepo.currentUser;
  // final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('base_url')}/api/update_order/${order.id}';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.orderEditortoMap()),
  );
  print(order.orderEditortoMap());
  if(json.decode(response.body)['data'] == true) return true;

  return false;
}

Future<bool> takeThisOrder(Order order) async {
  TakeOrder takeOrder = TakeOrder();
  takeOrder.driverId = userRepo.currentUser.id;
  takeOrder.orderId = order.id;
  final String url = '${GlobalConfiguration().getString('base_url')}/api/take_order';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(takeOrder.toMap()),
  );
  print(response.body);
  if(json.decode(response.body)['data'] == true) return true;

  return false;
}

Future<Order> updateOrderStatus(OrderStatusUpdate orderStUp) async {
  final String url = '${GlobalConfiguration().getString('base_url')}/api/update_order';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(orderStUp.toMap()),
  );
  print(response.body);
  
  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<Restaurant> updateRestaurantStatus(Restaurant restaurant) async {
  final String url = '${GlobalConfiguration().getString('base_url')}/api/update_rest_status';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(restaurant.toMap()),
  );
  print(response.body);
  
  return Restaurant.fromJSON(json.decode(response.body)['data']);
}

Future<Order> addOrder(Order order, Payment payment) async {
  /*
  User _user = userRepo.currentUser;
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  print(response.body);
  return Order.fromJSON(json.decode(response.body)['data']);*/
}
