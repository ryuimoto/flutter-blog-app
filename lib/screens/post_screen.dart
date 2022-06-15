import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/post_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostScreen extends StatefulWidget{
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  //get all posts
  Future<void> retrivePosts() async{
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState((){
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false),
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState(){
    
  }

  @override
  Widget build(BuildContext context){
    return _loading ? Center(child: CircularProgressIndicator()) :
        ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context,int index){
              Post post = _postList[index];
              return Text('${post.body}');
            },
        );
  }
}