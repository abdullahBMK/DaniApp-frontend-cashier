import 'dart:async';

import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;
  bool refreshState = false;
  Timer _timer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
  RefreshIndicatorState>();
  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
    _timer = new Timer.periodic(const Duration(seconds: 10), (timer) {
      _con.newOrders();
    });
  }

  @override
  void initState() {
    _con.listenForOrders();
    super.initState();
  }

    @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).orders,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: _con.refreshOrders,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _con.orders.isEmpty
                    ? InkWell(
                      onTap: (){
                        setState(() { refreshState = true; });
                        _con.refreshOrders();
                      },
                      child: CircularLoadingWidget(height: 500,refresh:refreshState)
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.orders.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: theme,
                            child: ExpansionTile(
                              backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/OrderDetails',
                                      arguments: RouteArgument(id: _con.orders.elementAt(index).id)).then((value) {
                                        _con.refreshOrders();
                                      });
                                },
                              ),
                              leading: _con.orders.elementAt(index).orderStatus.id == '5'
                                  ? Container(
                                      width: 60,
                                      height: 60,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: _con.orders.elementAt(index).orderStatus.id == '6' ? Colors.red.withOpacity(0.3) :Theme.of(context).hintColor.withOpacity(0.1)),
                                      child: Icon(
                                        _con.orders.elementAt(index).orderStatus.id == '6' ? Icons.cancel
                                        :Icons.update,
                                        color: Theme.of(context).hintColor.withOpacity(0.8),
                                        size: 30,
                                      ),
                                    ),
                              initiallyExpanded: true,
                              title: Text('${S.of(context).order_id}: #${_con.orders.elementAt(index).id}'),
                              subtitle: Text(
                                _con.orders.elementAt(index).deliveryAddress?.address ??
                                    S.of(context).address_not_provided_contact_client,
                                style: Theme.of(context).textTheme.caption,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                              children: _con.orders.elementAt(index).foodOrders != null ?
                              List.generate(_con.orders.elementAt(index).foodOrders.length, (indexFood) {
                                return OrderItemWidget(
                                    heroTag: 'my_orders',
                                    order: _con.orders.elementAt(index),
                                    foodOrder: _con.orders.elementAt(index).foodOrders.elementAt(indexFood));
                              }):
                              List.generate(0, (indexFood) {
                                return SizedBox(height: 0,);
                              })
                              ,
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}