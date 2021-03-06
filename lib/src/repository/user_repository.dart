import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

User currentUser = new User();
Address deliveryAddress = new Address();

Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  print(url);
  if (response.statusCode == 200) {
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser;
}

Future<void> logout() async {
  currentUser = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.clear();
  if (prefs.containsKey('current_user')) {
    currentUser = User.fromJSON(json.decode(await prefs.get('current_user')));
  }
  return currentUser;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard = CreditCard.fromJSON(json.decode(await prefs.get('credit_card')));
  }
  return _creditCard;
}

Future<User> update(User user,{token = false}) async {
  final String _apiToken = 'api_token=${currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getString('base_url')}/api/users/${currentUser.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url, 
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser = User.fromJSON(json.decode(response.body)['data']);
  return currentUser;
}

Future<Stream<Address>> getAddresses() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Address.fromJSON(data);
  });
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}
