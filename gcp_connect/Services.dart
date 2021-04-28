import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Products.dart';

class Services {
  static const ROOT = "35.226.156.119";
  static const String _GET_ALL_ACTION = "GET_ALL";
  static const String _ADD_ACTION = "ADD";
  static const String _UPDATE_ACTION = "UPDATE";
  static const String _DELETE_ACTION = "DELETE";

  static Future<List<Products>> getProducts() async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _GET_ALL_ACTION;
      print("here");
      final response = await http.post(ROOT+"/add_pr", body: map);
      print(response.statusCode);
      if (200 == response.statusCode) {
        List<Products> list = parseResponse(response.body);
        print("success");
        return list;
      } else {
        print("error1");
        return List<Products>();
      }
    } catch (e) {
      print(e);
      return List<Products>();
    }
  }

  static List<Products> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Products>((json) => Products.fromJson(json)).toList();
  }

  static Future<String> addProduct(int product_id, String product_name,
      String brand_name, String subhead,
      String description, double avg_rating, int num_ratings) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _ADD_ACTION;
      map["product_id"] = product_id;
      map["product_name"] = product_name;
      map["brand_name"] = brand_name;
      map["subhead"] = subhead;
      map["description"] = description;
      map["avg_rating"] = avg_rating;
      map["num_ratings"] = num_ratings;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }

  static Future<String> updateProduct(int product_id, String product_name,
      String brand_name, String subhead,
      String description, double avg_rating, int num_ratings) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _UPDATE_ACTION;
      map["product_id"] = product_id;
      map["product_name"] = product_name;
      map["brand_name"] = brand_name;
      map["subhead"] = subhead;
      map["description"] = description;
      map["avg_rating"] = avg_rating;
      map["num_ratings"] = num_ratings;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }

  static Future<String> deleteProduct(int product_id) async{
    try{
      var map = Map<String, dynamic>();
      map["action"] = _DELETE_ACTION;
      map["product_id"] = product_id;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "Error";
      }
    } catch(e){
      return "Error";
    }

  }
}

