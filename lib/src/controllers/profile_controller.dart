import 'package:deliveryboy/src/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../repository/order_repository.dart';
import '../repository/user_repository.dart';
import '../models/restaurant.dart';

class ProfileController extends ControllerMVC {
  User user = new User();
  List<Order> recentOrders = [];
  Restaurant restaurant;
  GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForUser();
    listenForRestaurant();
  }

  void listenForUser() {
    getCurrentUser().then((_user) {
      setState(() {
        user = _user;
      });
    });
  }
  


  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurant(currentUser.restaurant.id);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
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

  void listenForUpdateRestaurant(val) async {
    Restaurant rest = Restaurant();
    rest.id = currentUser.restaurant.id;
    rest.available = val;
      await updateRestaurantStatus(rest).then((value) {
      try {
        restaurant = value;
        setState((){});
      } catch (e) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.verify_your_internet_connection),
        ));
      }
    });
  }
  void listenForRecentOrders({String message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshProfile() async {
    recentOrders.clear();
    user = new User();
    listenForRecentOrders(message: S.current.orders_refreshed_successfuly);
    listenForUser();
  }
}
