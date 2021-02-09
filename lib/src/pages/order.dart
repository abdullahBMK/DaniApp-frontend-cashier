import 'dart:async';

import 'package:deliveryboy/src/controllers/order_details_controller.dart';
import 'package:deliveryboy/src/elements/DrawerWidget.dart';
import 'package:deliveryboy/src/elements/OrderItemWidget.dart';
import 'package:deliveryboy/src/elements/ShoppingCartButtonWidget.dart';
import 'package:deliveryboy/src/models/order_status_update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smart_select/smart_select.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../generated/i18n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import 'maps.dart';

class OrderWidget extends StatefulWidget {
  RouteArgument routeArgument;

  OrderWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends StateMVC<OrderWidget> {
  OrderDetailsController _con;
  String value = '';
  bool visible = false;
  _OrderWidgetState() : super(OrderDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrder(id: widget.routeArgument.id);
    super.initState();
  }



  
  List<SmartSelectOption<String>> options = [
      SmartSelectOption<String>(value: '1', title: 'Order Received'),
      SmartSelectOption<String>(value: '2', title: 'Preparing'),
      SmartSelectOption<String>(value: '3', title: 'Ready'),
      SmartSelectOption<String>(value: '4', title: 'On the Way'),
      SmartSelectOption<String>(value: '6', title: 'Cancel'),
    ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
        floatingActionButton: Visibility(
          visible: _con.order?.orderStatus?.id == '5' ||  _con.order?.orderStatus?.id == '6' ? false : true,
          child: SpeedDial(
            
            // both default to 16
            marginRight: (MediaQuery.of(context).size.width - 30) /2,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            // visible: _dialVisible,
            // If true user is forced to close dial manually 
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.cancel),
                backgroundColor: Colors.red,
                label: S.current.cancel,
                labelStyle: TextStyle(fontSize: 18.0),
                  onTap: (){
                    showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).cancel_confirmation),
                      content: Text(S
                          .of(context)
                          .would_you_please_confirm_if_you_have_cancel_all_meals),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        FlatButton(
                          child: new Text(S.of(context).confirm),
                          onPressed: () {
                            OrderStatusUpdate ordCh = OrderStatusUpdate();
                            ordCh.id = _con.order.id;
                            ordCh.orderStatusId = '6';
                            _con.listenForUpdateOrder(ordCh);
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: new Text(S.of(context).dismiss),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
                  }
              ),
              SpeedDialChild(
                child: Icon(Icons.mode_edit),
                backgroundColor: Colors.blue,
                label: S.current.edit,
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.of(context).pushNamed('/OrderEditor',
                            arguments: RouteArgument(param: _con.order))
                            .then((value) => _con.listenForOrder(id: widget.routeArgument.id));
                },
              ),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.checkCircle),
                backgroundColor: Colors.green,
                label: S.current.delivered,
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).delivery_confirmation),
                      content: Text(S
                          .of(context)
                          .would_you_please_confirm_if_you_have_delivered_all_meals),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        FlatButton(
                          child: new Text(S.of(context).confirm),
                          onPressed: () {
                            _con.doDeliveredOrder(_con.order);
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: new Text(S.of(context).dismiss),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).order_details,
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshOrder,
          child: _con.order == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: _con.order.orderStatus.id == '5' ? 147 : 160),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).focusColor.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  _con.order.orderStatus.id == '5'
                                      ? Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
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
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).hintColor.withOpacity(0.1)),
                                          child: Icon(
                                            Icons.update,
                                            color: Theme.of(context).hintColor.withOpacity(0.8),
                                            size: 30,
                                          ),
                                        ),
                                  SizedBox(width: 15),
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                S.of(context).order_id + "#${_con.order.id}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                              Text(
                                                _con.order.payment?.method ?? S.of(context).cash_on_delivery,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm').format(_con.order.dateTime), 
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   width: 42,
                                            //   height: 42,
                                              // child: FlatButton(
                                              //   padding: EdgeInsets.all(0),
                                              //   disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                              //   onPressed: () {
                                              //     Navigator.of(context).pushNamed('/OrderEditor',
                                              //         arguments: RouteArgument(param: _con.order));
                                              //   },
                                              //   child: Icon(
                                              //     Icons.edit,
                                              //     color: Theme.of(context).primaryColor,
                                              //     size: 24,
                                              //   ),
                                              //   color: Theme.of(context).accentColor.withOpacity(0.9),
                                              //   shape: StadiumBorder(),
                                              // ),
                                            // ),
                                            // SizedBox(height: 5,),
                                            // Helper.getPrice(_con.total, style: Theme.of(context).textTheme.display1),
                                            _con.order.foodOrders != null ?
                                            Text(
                                              'Items: ${_con.order.foodOrders.length}',
                                              style: Theme.of(context).textTheme.caption,
                                            ): Text(
                                              '',
                                              style: Theme.of(context).textTheme.caption,
                                            )
                                            ,
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.person_pin,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  'Customer',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.user.name,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                      onPressed: () {
                                  //  Navigator.of(context).pushNamed('/Profile',
                                  //      arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                      },
                                      child: Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.deliveryAddress?.address ??
                                          S.of(context).address_not_provided_please_call_the_client,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                     onPressed: () {
                                       MapUtils.openMap(double.parse(_con.order.deliveryAddress.latitude),double.parse(_con.order.deliveryAddress.longitude));
                                      //  Navigator.of(context).pushNamed('/Map',
                                      //      arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                      // print(_con.order.deliveryAddress.latitude);
                                     },
                                      child: Icon(
                                        Icons.directions,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.order.user.phone,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        launch("tel:${_con.order.user.phone}");
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _con.order.orderStatus.id != '5' && _con.order.orderStatus.id != '6'?
                            SmartSelect<String>.single(
                              leading: Icon(
                                Icons.timelapse,
                                color: Theme.of(context).hintColor,
                              ),
                              title: 'Order Status',
                              value: _con.order.orderStatus.id,
                              options: options,
                              onChange: (val){
                                OrderStatusUpdate ordCh = OrderStatusUpdate();
                                ordCh.id = _con.order.id;
                                ordCh.orderStatusId = val;
                                _con.listenForUpdateOrder(ordCh);
                              }
                            ) : SizedBox(height: 0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.fastfood,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).foods_ordered,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                            _con.order.foodOrders != null ?
                            ListView.separated(
                              padding: EdgeInsets.only(bottom: 50),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.order.foodOrders.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15);
                              },
                              itemBuilder: (context, index) {
                                return OrderItemWidget(
                                    heroTag: 'my_orders',
                                    order: _con.order,
                                    foodOrder: _con.order.foodOrders.elementAt(index));
                              },
                            ) :
                            Text('')
                            ,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 170 ,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).focusColor.withOpacity(0.15),
                                  offset: Offset(0, -2),
                                  blurRadius: 5.0)
                            ]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).subtotal,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.subTotal, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              SizedBox(height: 5),
                               Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).coupon_discount} (${_con.order.coupon}%)", 
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(-_con.discount, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).delivery_fee}", 
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.order.deliveryFee, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).tax} (${setting.value.defaultTax}%)",
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.taxAmount, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              Divider(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).total,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  Helper.getPrice(_con.total, style: Theme.of(context).textTheme.title)
                                ],
                              ),
                              // SizedBox(height: 10),
                              // _con.order.orderStatus.id != '5'
                              //     ? SizedBox(
                              //         width: MediaQuery.of(context).size.width - 40,
                              //         child: FlatButton(
                              //           onPressed: () {
                              //             showDialog(
                              //                 context: context,
                              //                 builder: (context) {
                              //                   return AlertDialog(
                              //                     title: Text(S.of(context).delivery_confirmation),
                              //                     content: Text(S
                              //                         .of(context)
                              //                         .would_you_please_confirm_if_you_have_delivered_all_meals),
                              //                     actions: <Widget>[
                              //                       // usually buttons at the bottom of the dialog
                              //                       FlatButton(
                              //                         child: new Text(S.of(context).confirm),
                              //                         onPressed: () {
                              //                           _con.doDeliveredOrder(_con.order);
                              //                           Navigator.of(context).pop();
                              //                         },
                              //                       ),
                              //                       FlatButton(
                              //                         child: new Text(S.of(context).dismiss),
                              //                         onPressed: () {
                              //                           Navigator.of(context).pop();
                              //                         },
                              //                       ),
                              //                     ],
                              //                   );
                              //                 });
                              //           },
                              //           padding: EdgeInsets.symmetric(vertical: 14),
                              //           color: Theme.of(context).accentColor,
                              //           shape: StadiumBorder(),
                              //           child: Text(
                              //             S.of(context).delivered,
                              //             textAlign: TextAlign.start,
                              //             style: TextStyle(color: Theme.of(context).primaryColor),
                              //           ),
                              //         ),
                              //       )
                              //     : SizedBox(height: 0),
                              // SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}
