
class Driver {
  String id;
  String name;

//  String role;

  Driver();

  Driver.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;

    return map;
  }
}
