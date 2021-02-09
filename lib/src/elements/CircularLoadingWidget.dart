import 'dart:async';

import 'package:flutter/material.dart';

class CircularLoadingWidget extends StatefulWidget {
  double height;
  bool refresh = false;

  CircularLoadingWidget({Key key, this.height,this.refresh}) : super(key: key);

  @override
  _CircularLoadingWidgetState createState() => _CircularLoadingWidgetState();
}

class _CircularLoadingWidgetState extends State<CircularLoadingWidget> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  bool _mounted = false;


  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween<double>(begin: widget.height, end: 0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    Timer(Duration(seconds: 10), () {
      if (mounted) {
        animationController.forward().then((value){
          setState(() {
            _mounted = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
//    Timer(Duration(seconds: 30), () {
//      //if (mounted) {
//      //}
//    });
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: SizedBox(
        height: animation.value == 0 ? widget.height : animation.value,
        child: new Center(
          child: _mounted ? 
            FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: null
            )
          : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
