import 'dart:io';

import 'package:blog_app/constant.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget{
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text,image);

    if(response.error == null){
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false)
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState((){
        _loading = !_loading;
      });
    }
  }
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new post'),
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) : ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
                image: _imageFile == null ? null : DecorationImage(
                    image: FileImage(_imageFile ?? File('')),
                    fit: BoxFit.cover
                )
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image,size: 50,color: Colors.black38),
                onPressed: (){
                  getImage();
                },
              ),
            ),
          ),
          Form(
            key: _formKey,

            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: _txtControllerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val) => val!.isEmpty ? 'Post body is required' : null,
                decoration: InputDecoration(
                  hintText: 'Post body...',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black38)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton('Post', (){
              if(_formKey.currentState!.validate()){
                setState((){
                  _loading = !_loading;
                });
                _createPost();
              }
            }),
          ),
        ],
      ),
    );
  }
}
