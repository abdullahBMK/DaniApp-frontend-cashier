import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../helpers/swipe_widget.dart';
import '../models/notification.dart' as model;

// class NotificationItemWidget extends StatelessWidget {
//   model.Notification notification;
//   VoidCallback onMarkAsRead;
//   VoidCallback onMarkAsUnRead;
//   VoidCallback onRemoved;

//   NotificationItemWidget({Key key, this.notification, this.onMarkAsRead, this.onMarkAsUnRead, this.onRemoved})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return OnSlide(
//       backgroundColor: notification.read ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor,
//       items: <ActionItems>[
//         ActionItems(
//             icon: new IconButton(
//               icon: notification.read ? new Icon(Icons.panorama_fish_eye) : new Icon(Icons.brightness_1),
//               onPressed: () {},
//               color: Theme.of(context).accentColor,
//             ),
//             onPress: () {
//               if (notification.read) {
//                 onMarkAsUnRead();
//               } else {
//                 onMarkAsRead();
//               }
//             },
//             backgroudColor: Theme.of(context).scaffoldBackgroundColor),
//         new ActionItems(
//             icon: new IconButton(
//               padding: EdgeInsets.only(right: 10),
//               icon: new Icon(Icons.delete),
//               onPressed: () {
//                 print('onPressed');
//               },
//               color: Theme.of(context).accentColor,
//             ),
//             onPress: () {
//               onRemoved();
//             },
//             backgroudColor: Theme.of(context).scaffoldBackgroundColor),
//       ],
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               child: Image.asset(
//                   'assets/img/bell.png',
//                   fit: BoxFit.cover,
//                   height: 50,
//                   width: 50,
//                 ),
//             ),
//             SizedBox(width: 15),
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   Text(
//                     this.notification.title,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     textAlign: TextAlign.justify,
//                     style: Theme.of(context)
//                         .textTheme
//                         .body2
//                         .merge(TextStyle(fontWeight: notification.read ? FontWeight.w300 : FontWeight.w600)),
//                   ),
//                   Text(
//                     DateFormat('yyyy-MM-dd').format(notification.dateTime),
//                     style: Theme.of(context).textTheme.caption,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class NotificationItemWidget extends StatelessWidget {
  model.Notification notification;
//   model.Notification notification;
  VoidCallback onMarkAsRead;
  VoidCallback onMarkAsUnRead;
  VoidCallback onRemoved;

  NotificationItemWidget({Key key, this.notification, this.onMarkAsRead, this.onMarkAsUnRead, this.onRemoved})
      : super(key: key);
  // NotificationItemWidget({Key key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
              if (notification.read) {
                onMarkAsUnRead();
              } else {
                onMarkAsRead();
              }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15),
                width: 55,
                height: 75,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                      Theme.of(context).focusColor.withOpacity(0.7),
                      Theme.of(context).focusColor.withOpacity(0.05),
                    ])),
                child: Icon(
                  Icons.notifications,
                   color: notification.read ?  Theme.of(context).primaryColor : Colors.orangeAccent[200],
                  size: 35,
                ),
              ),
              Positioned(
                right: -30,
                bottom: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  Helper.trans(notification.type2),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(notification.dateTime),
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
