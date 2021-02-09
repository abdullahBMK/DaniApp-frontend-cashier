import '../models/notification_type.dart';

class Notification {
  String id;
  String title;
  NotificationType type;
  String type2;
  bool read;
  DateTime dateTime;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    title = jsonMap['title'] != null ? jsonMap['title'].toString() : '';
    type2 = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
    type = jsonMap['notification_type'] != null
        ? NotificationType.fromJSON(jsonMap['notification_type'])
        : new NotificationType();
    read = jsonMap['read_at'] == null ? false : true;
    dateTime = DateTime.parse(jsonMap['updated_at']);
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read"] = !read;
    return map;
  }
}
