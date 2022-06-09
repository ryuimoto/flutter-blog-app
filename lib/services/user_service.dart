import 'dart:convert';

import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/models/user.dart';
import 'package:http/http.dart' as http;


Future<ApiResponse> login (String email,String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email,'password' : password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];

    }
  }
  catch(e){

  }
}