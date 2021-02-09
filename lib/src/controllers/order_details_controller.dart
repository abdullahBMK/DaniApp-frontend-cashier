import 'package:deliveryboy/src/models/driver.dart';
import 'package:deliveryboy/src/models/order_status_update.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smart_select/smart_select.dart';

import '../../generated/i18n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderDetailsController extends ControllerMVC {
  Order order , orderEditor;
  List<Driver> drivers = <Driver>[];
  List<SmartSelectOption<String>> driverOptions ;
  double taxAmount = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  double discount = 0.0;
  String value;
  bool check = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKeyeditor;

  OrderDetailsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.scaffoldKeyeditor = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({String id, String message}) async {
    final Stream<Order> stream = await getOrder(id);
    stream.listen((Order _order) {
      setState(() => order = _order);
      // print(order.toMap());
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if(order.foodOrders != null)
      calculateSubtotal();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForDriver({String id, String message}) async {
    driverOptions = <SmartSelectOption<String>>[];
    driverOptions.add(SmartSelectOption<String>(value: '', title: 'Select One'));
    final Stream<Driver> stream = await getDrivers(id);
    stream.listen((Driver _driver) {
      drivers.add(_driver);
      driverOptions.add(SmartSelectOption<String>(value: _driver.id, title: _driver.name));
      setState((){});
      // print(drivers.length.toString() + "------------------------------------");
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
       setState((){});
      // if(order.foodOrders != null)
      // calculateSubtotal();
      // if (message != null) {
      //   scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text(message),
      //   ));
      // }
    });
  }

  void listenForUpdateOrder(OrderStatusUpdate orderStUp) async {
    var oldOrder = order;
    setState(()=> order = null);
    await updateOrderStatus(orderStUp).then((value) {
      try {
        listenForOrder(id:orderStUp.id,message: "Order Status Changed");
      } catch (e) {
        setState(()=> order = oldOrder);
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }
    });
    // stream.listen((Order _order) {
    //   setState(() => order = _order);
    //   // print(order.toMap());
    // }, onError: (a) {
    //   print(a);
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(S.current.verify_your_internet_connection),
    //   ));
    // }, onDone: () {
    //     scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Text("Order Status Changed"),
    //     ));
    // });
  }


  Future<void> refreshOrder() async {
    listenForOrder(id: order.id, message: S.current.order_refreshed_successfuly);
  }

  void doDeliveredOrder(Order _order) async {
    deliveredOrder(_order).then((value) {
      setState(() {
        this.order.orderStatus.id = '5';
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('The order deliverd successfully to client'),
      ));
    });//.then((value) => Navigator.of(scaffoldKey.currentContext).pop()).catchError((onError){Navigator.of(scaffoldKey.currentContext).pop();});
  }

  Future<bool> dotakeThisOrder(Order _order) async {
    try {
      takeThisOrder(_order).then((value) {
        setState((){
           order = null ; check = false;
        });
        if(value == true){
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Done successfully'),
          ));
           Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/OrderDetails',
            arguments: RouteArgument(id: _order.id));
        }
        else{
          // check = false;
          listenForOrder(id:_order.id,message: "There is a problem or was taken from another driver");
          // Navigator.of(scaffoldKey.currentContext).pop();
        }
        setState((){});
      });

      return check;
    } catch (e) {
      listenForOrder(id:_order.id,message: "There is a problem or was taken from another driver");
    }
  }

  Future<bool> updateOrder(Order _order) async {
    try {
      updateOrders(_order).then((value) {
        if(value == true){
          scaffoldKeyeditor.currentState.showSnackBar(SnackBar(
            content: Text(S.current.order_updated_successfully),
          ));
           
        }
        else{
          scaffoldKeyeditor.currentState.showSnackBar(SnackBar(
            content: Text(S.current.verify_your_internet_connection),
          ));
        }
        setState((){});
      });

      return check;
    } catch (e) {
      // listenForOrder(id:_order.id,message: "There is a problem or was taken from another driver");
    }
  }

  void calculateSubtotal() async {
    subTotal = 0;
    discount = 0;
    order.foodOrders.forEach((food) {
      if(food != null)
      subTotal += food.quantity * food.price;
    });
    discount =  (subTotal * (order.coupon / 100));
    // subTotal = subTotal - (subTotal * (order.coupon / 100));
    taxAmount = subTotal * order.tax / 100;
    total = subTotal + taxAmount - discount + order.deliveryFee;
    setState(() {});
  }
}
