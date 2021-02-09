class Coupon {
  String code;
  String marketId;
  double value;
  double start;
  DateTime dateExp;
  bool forAll;
  bool v;

  Coupon();

  Coupon.fromJSON(Map<String, dynamic> jsonMap) {
    // print('++++++++++++++++++'+jsonMap['start'].toString());
    code = jsonMap['code'].toString();
    marketId = jsonMap['market_id'].toString();
    value = jsonMap['value'] != null ? double.parse(jsonMap['value']) : 0.0;
    start = jsonMap['start'] != null ? double.parse(jsonMap['start']) : 0.0;
    dateExp = jsonMap['date_exp'] != null ? DateTime.parse( jsonMap['date_exp'] ) : null ;
    forAll = jsonMap['all_products'] == '0' ? false : true;
    v = true;
  }

  Coupon.fromJSONFalse() {
    v= false;
  }

}
