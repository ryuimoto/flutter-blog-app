import 'package:blog_app/models/api_response.dart';
import 'package:flutter/services.dart';
import 'package:blog_app/constant.dart';
import 'package:blog_app/services/user_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ApiResponse> getComments(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(Uri.parse('$postsURL/$postId/comments'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['comments'].map((p) => Comment.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 402:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}