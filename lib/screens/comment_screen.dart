import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/comments_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget{
  final int? postId;

  CommentScreen({
      this.postId
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;

  // Get comments
  Future<void> _getComemnts() async{
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if(response.error == null){
      setState(){
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      }
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false)
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
      );
  }
}