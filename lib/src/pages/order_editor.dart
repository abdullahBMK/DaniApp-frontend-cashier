import 'package:deliveryboy/src/controllers/order_details_controller.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smart_select/smart_select.dart';

import '../../config/app_config.dart' as config;
import '../../generated/i18n.dart';
import '../elements/BlockButtonWidget.dart';
import '../repository/user_repository.dart' as userRepo;

class OrderEditor extends StatefulWidget {
  RouteArgument routeArgument;

  OrderEditor({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderEditorState createState() => _OrderEditorState();
}

class _OrderEditorState extends StateMVC<OrderEditor> {
  OrderDetailsController _con;
  

  _OrderEditorState() : super(OrderDetailsController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    _con.orderEditor  = widget.routeArgument.param as Order;
    _con.listenForDriver(id: _con.orderEditor.foodOrders[0].food.restaurant.id);
  }

String value = '';
List<SmartSelectOption<String>> options = [
  SmartSelectOption<String>(value: 'Waiting for Client', title: 'Waiting for Client'),
  SmartSelectOption<String>(value: 'Not Paid', title: 'Order not paid yet'),
  SmartSelectOption<String>(value: 'Paid', title: 'Paid'),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKeyeditor,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          // Positioned(
          //   top: 0,
          //   child: Container(
          //     width: config.App(context).appWidth(100),
          //     height: config.App(context).appHeight(37),
          //     decoration: BoxDecoration(color: Theme.of(context).accentColor),
          //   ),
          // ),
          // Positioned(
          //   top: config.App(context).appHeight(37) - 120,
          //   child: Container(
          //     width: config.App(context).appWidth(84),
          //     height: config.App(context).appHeight(37),
          //     child: Text(
          //       S.of(context).lets_start_with_login,
          //       style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Theme.of(context).primaryColor)),
          //     ),
          //   ),
          // ),
          Positioned(
            top: config.App(context).appHeight(15) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _con.scaffoldKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text(_con.orderEditor.driverId),
                    SmartSelect<String>.single(
                      title: 'Payment status',
                      value: _con.orderEditor.payment.status,
                      options: options,
                      modalType: SmartSelectModalType.bottomSheet,
                      onChange: (val) => setState(() => _con.orderEditor.payment.status = val),
                    ),
                    SizedBox(height: 5),
                    SmartSelect<String>.single(
                      title: 'Driver',
                      value: _con.orderEditor.driverId,
                      options: _con.driverOptions,
                      modalType: SmartSelectModalType.bottomSheet,
                      onChange: (val) => setState(() => _con.orderEditor.driverId = val),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      initialValue: _con.orderEditor.tax.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (input) => _con.orderEditor.tax = double.parse(input),
                      //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).tax,
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '0',
                        hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(FontAwesomeIcons.handHoldingUsd, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: _con.orderEditor.deliveryFee.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (input) => _con.orderEditor.deliveryFee = double.parse(input),
                      //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).delivery_fee,
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '0',
                        hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(FontAwesomeIcons.biking, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: _con.orderEditor.orderTime.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (input) => _con.orderEditor.orderTime = double.parse(input),
                      //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).processing_time,
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '0',
                        hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(FontAwesomeIcons.stopwatch, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    SingleChildScrollView(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: _con.orderEditor.hint,
                        maxLines: 5,
                        onChanged: (input) => _con.orderEditor.hint = input,
                        //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).hint,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Hint',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(FontAwesomeIcons.envelopeOpenText, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).save,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        _con.updateOrder(_con.orderEditor);
                      },
                    ),
                    // SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   child: Column(
          //     children: <Widget>[
          //       FlatButton(
          //         onPressed: () {
          //           // Navigator.of(context).pushReplacementNamed('/SignUp');
          //         },
          //         textColor: Theme.of(context).hintColor,
          //         child: Text(S.of(context).i_forgot_password),
          //       ),
          //       FlatButton(
          //         onPressed: () {
          //           Navigator.of(context).pushReplacementNamed('/SignUp');
          //         },
          //         textColor: Theme.of(context).hintColor,
          //         child: Text(S.of(context).i_dont_have_an_account),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
