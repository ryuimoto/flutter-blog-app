import 'package:blog_app/constant.dart';
import 'package:flutter/material.dart';

class PostForm extends StatefulWidget{
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;


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
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image,size: 50,color: Colors.black38),
                onPressed: (){

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
              }
            }),
          ),
        ],
      ),
    );
  }
}