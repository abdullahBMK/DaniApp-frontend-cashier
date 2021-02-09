import 'package:deliveryboy/src/pages/orders.dart';
import 'package:deliveryboy/src/pages/orders_history.dart';
import 'package:deliveryboy/src/pages/orders_pending.dart';
import 'package:deliveryboy/src/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../elements/DrawerWidget.dart';
import '../pages/profile.dart';

// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  int currentTab;
  Widget currentPage = OrdersWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesTestWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 1;
  }

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesTestWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      print(currentUser.deviceToken);
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = ProfileWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = OrdersHistoryWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        // case 3:
        //   widget.currentPage = OrdersPendingWidget(parentScaffoldKey: widget.scaffoldKey);
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            print(i);
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            widget.currentTab == 0 ?
            BottomNavigationBarItem(
              icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
                ),
              title: new Container(height: 0.0),
            )
            :BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: new Container(height: 0.0),
            ),
            widget.currentTab == 1 ?
            BottomNavigationBarItem(
                title: new Container(height: 5.0),
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
                )):BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: new Container(height: 0.0),
            ),
            widget.currentTab == 2 ?
            BottomNavigationBarItem(
              icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.history, color: Theme.of(context).primaryColor),
                ),
              title: new Container(height: 0.0),
            )
            :BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              title: new Container(height: 0.0),
            ),
            // widget.currentTab == 3 ?
            // BottomNavigationBarItem(
            //   icon: Container(
            //       width: 42,
            //       height: 42,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).accentColor,
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(50),
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
            //           BoxShadow(
            //               color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
            //         ],
            //       ),
            //       child: new Icon(Icons.timeline, color: Theme.of(context).primaryColor),
            //     ),
            //   title: new Container(height: 0.0),
            // )
            // :BottomNavigationBarItem(
            //   icon: Icon(Icons.timeline),
            //   title: new Container(height: 0.0),
            // ),
          ],
        ),
      ),
    );
  }
}
