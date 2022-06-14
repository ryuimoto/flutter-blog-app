import 'dart:convert';
import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:blog_app/constant.dart';
import '../models/post.dart';

// get all posts
Future<ApiResponse> getPosts() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(Uri.parse(postsURL),
    headers:{
        'Accept': 'application/json',
        'Authorization' : 'Bearer $token',
    });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p));
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}