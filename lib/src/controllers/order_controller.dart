import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:soundpool/soundpool.dart';
import '../../generated/i18n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders  = <Order>[];
  List<Order> newOrdersList  = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrders({String message}) async {
    // print('listenForOrders');
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      // print(orders[0].user.toMap());
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForPendingOrders({String message}) async {
    final Stream<Order> stream = await getPendingOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForOrdersHistory({String message}) async {
    final Stream<Order> stream = await getOrdersHistory();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrders() async {
    setState((){orders.clear();});
    listenForOrders(message: S.current.order_refreshed_successfuly);
  }

  Future<void> newOrders() async {
    newOrdersList.clear();
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        newOrdersList.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      // print(orders[0].user.toMap());
      // alertFor();
      
      if(newOrdersList?.length != orders?.length && newOrdersList.isNotEmpty){
       if(orders.length < newOrdersList.length) alertFor();
       
        orders.clear();
        orders = newOrdersList;
        setState((){});
      }

      
      
    });
    // listenForOrders(message: S.current.order_refreshed_successfuly);
  }

  alertFor() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("assets/sounds/new-order.mp3").then((ByteData soundData) {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
  }

  Future<void> refreshPendingOrders() async {
    setState((){orders.clear();});
    listenForPendingOrders(message: S.current.order_refreshed_successfuly);
  }
}
